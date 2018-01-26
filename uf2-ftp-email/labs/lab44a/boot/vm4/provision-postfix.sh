#!/bin/bash
set -eux
apt update
config_domain=$(hostname --domain)

# these anwsers were obtained (after installing postfix-cdb) with:
#
#   #sudo debconf-show postfix
#   sudo apt-get install debconf-utils
#   # this way you can see the comments:
#   sudo debconf-get-selections
#   # this way you can just see the values needed for debconf-set-selections:
#   sudo debconf-get-selections | grep -E '^postfix\s+' | sort
debconf-set-selections<<EOF
postfix postfix/main_mailer_type select Internet Site
postfix postfix/mailname string $config_domain
EOF

apt-get install -y --no-install-recommends postfix-cdb

# stop postfix before we configure it.
systemctl stop postfix

# add the user that will manage all the virtual mailboxes.
addgroup vmail
adduser --disabled-login --ingroup vmail --no-create-home --home /var/vmail --gecos '' vmail
# create the virtual mailboxes store.
# NB Postfix will automatically create the needed directories/files/maildirs under /var/vmail.
install -d -o vmail -g vmail -m 700 /var/vmail

# set virtual domains.
cat >/etc/postfix/virtual_mailbox_domains <<EOF
$config_domain                  20080428
EOF

# set physical mailboxes.
cat >/etc/postfix/virtual_mailbox_maps <<EOF
alice@$config_domain            $config_domain/alice/
bob@$config_domain              $config_domain/bob/
carol@$config_domain            $config_domain/carol/
dave@$config_domain             $config_domain/dave/
eve@$config_domain              $config_domain/eve/
frank@$config_domain            $config_domain/frank/
grace@$config_domain            $config_domain/grace/
henry@$config_domain            $config_domain/henry/
EOF

# set aliases.
cat >/etc/postfix/virtual_alias_maps <<EOF
root@$config_domain             alice@$config_domain
abuse@$config_domain            alice@$config_domain
postmaster@$config_domain       alice@$config_domain
hostmaster@$config_domain       alice@$config_domain
mailer-daemon@$config_domain    alice@$config_domain
EOF

# rebuild the maps.
postmap cdb:/etc/postfix/virtual_mailbox_domains # (re)creates /etc/postfix/virtual_mailbox_domains.cdb
postmap cdb:/etc/postfix/virtual_mailbox_maps    # (re)creates /etc/postfix/virtual_mailbox_maps.cdb
postmap cdb:/etc/postfix/virtual_alias_maps      # (re)creates /etc/postfix/virtual_alias_maps.cdb

# update postfix configuration.
## fer que pugui resoldre per dns
postconf -e 'inet_protocols = ipv4'
postconf -e 'compatibility_level = 2'
postconf -e 'mydestination = localhost'
postconf -e 'virtual_mailbox_domains = cdb:/etc/postfix/virtual_mailbox_domains'
postconf -e 'virtual_mailbox_maps = cdb:/etc/postfix/virtual_mailbox_maps'
postconf -e 'virtual_alias_maps = cdb:/etc/postfix/virtual_alias_maps'
postconf -e 'virtual_mailbox_base = /var/vmail'
postconf -e 'virtual_minimum_uid = 1000'
postconf -e "virtual_uid_maps = static:`id -u vmail`"
postconf -e "virtual_gid_maps = static:`id -g vmail`"
postconf -e 'smtpd_banner = $myhostname ESMTP'
## poder enviar/rebre a adreces de la teva xarxa
postconf -e "mynetworks = 192.168.49.0/24 127.0.0.0/8"
## resolucio problema sender hostname or domain not found
postconf -e 'smtp_host_lookup = dns, native'
cat <<'EOF' >>/etc/postfix/main.cf
smtpd_sender_restrictions =
    reject_non_fqdn_sender,
    reject_unknown_sender_domain

smtpd_recipient_restrictions =
    permit_mynetworks,
    permit_sasl_authenticated,    
    reject_non_fqdn_recipient,
    reject_invalid_hostname,
    reject_unauth_destination,
##    permit_sasl_authenticated
    reject_unknown_client

smtpd_data_restrictions =
    reject_multi_recipient_bounce

strict_rfc821_envelopes = yes
smtpd_helo_required = yes
disable_vrfy_command = yes
EOF

# start postfix.
systemctl start postfix
