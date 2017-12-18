# LAB 42 - email server amb dns

- configura un servidor de dns per a una zona anomenada "inicial_1ercognom".test. Afegeix les entrades per a
 - màquina virtual 1: servidor dns
 - màquina virtual 2: servidor email MTA (postfix)
 - màquina virtual 3: servidor ftp
 - màquina virtual 4: client

- configura un servidor de correu MTA (postfix) a la màquina dos que faci ús del servidor de dns de la màquina 1

- consell: informa el FQDN al fitxer machines.yml: (exemple: dns.jiznardo.test, emailserver.jiznardo.test ... )


  - configura un servidor de noms primari (cache i forwarding) i un de secundari per a la única xarxa assignada
    - lab42vm1 - dns
    - lab42vm2 - emailserver
    - lab42vm3 - ftpserver
    - lab42vm4 - client1

  - el nom del domini serà <inicial_nom+cognom1.test>
  - ex: en el meu cas seria: jiznardo.test  
    
  - nota: canvia els noms de les màquines si ho necessites ;) (machines.xml).

- recorda de substituir XXX pel valor assignat al fitxer de xarxes assignades a cada persona.

- pots partir de la resolucio del lab22 que se troba a [aquest_link](https://goo.gl/6xJuzq)

