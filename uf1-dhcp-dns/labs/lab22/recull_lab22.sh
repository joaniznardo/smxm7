#!/bin/bash

## script per recollir la pràctica de DNS

export DIRTMP=out
export SHAREDDIR=/vagrant
export DIROUT=$SHAREDDIR/$DIRTMP
export DVM1=$DIRTMP/vm1
export DVM2=$DIRTMP/vm2
export DVM3=$DIRTMP/vm3
export DVM4=$DIRTMP/vm4

##
## possible millora: aprofitar el loop de ruby del Vagrantfile :)
##

export S1=$(grep name machines.yml | tail -4 | head -1 | awk '{print $2}' | sed -r 's/"//g')
export S2=$(grep name machines.yml | tail -3 | head -1 | awk '{print $2}' | sed -r 's/"//g')
export C1=$(grep name machines.yml | tail -2 | head -1 | awk '{print $2}' | sed -r 's/"//g')
export C2=$(grep name machines.yml | tail -1 | head -1 | awk '{print $2}' | sed -r 's/"//g')

export DIRBIND=/etc/bind
export GENERICCONF=named.conf.options
export ZONEDEF=named.conf.local

export ARESOLV=/etc
export RRESOLV=resolv.conf

export VALIDA=test_connectivitat.txt

export INTENTS=2

rm -rf $DIRTMP
mkdir -p $DVM1 $DVM2 $DVM3 $DVM4



##########  mv1  - server 1

#recupera opcions globals
vagrant ssh $S1 -c "cp {$DIRBIND,$SHAREDDIR/$DVM1}/$GENERICCONF"
#recupera declaració de zona
vagrant ssh $S1 -c "cp {$DIRBIND,$SHAREDDIR/$DVM1}/$ZONEDEF"

#determinar els fitxers de zona
export AF1=$(grep file $DVM1/$ZONEDEF | grep -v "//" | tail -2 | head -1 | awk '{print $2}' | sed -r 's/"//g'| sed -r 's/;//g')
export AF2=$(grep file $DVM1/$ZONEDEF | grep -v "//" | tail -1 | head -1 | awk '{print $2}' | sed -r 's/"//g'| sed -r 's/;//g')
export RF1=$(echo $AF1 | sed -r 's/;//g' | sed -r 's/\// /g' | awk '{print $NF}')
export RF2=$(echo $AF2 | sed -r 's/;//g' | sed -r 's/\// /g' | awk '{print $NF}')

export DOMAIN=$(grep "zone " $DVM1/$ZONEDEF | grep -v "//" | grep -v "file" | tail -2 | head -1 | awk '{print $2}' | sed -r 's/"//g'| sed -r 's/;//g')

#recupera els fitxers de zona
vagrant ssh $S1 -c "cp $AF1 $SHAREDDIR/$DVM1/$RF1"
vagrant ssh $S1 -c "cp $AF2 $SHAREDDIR/$DVM1/$RF2"

# test connectivitat - el primer tee crea - la resta afegeix
vagrant ssh $S1 -c "ping -c $INTENTS  $S1 | tee    $SHAREDDIR/$DVM1/$VALIDA" 
vagrant ssh $S1 -c "ping -c $INTENTS  $S2 | tee -a $SHAREDDIR/$DVM1/$VALIDA" 
vagrant ssh $S1 -c "ping -c $INTENTS  $C1 | tee -a $SHAREDDIR/$DVM1/$VALIDA" 
vagrant ssh $S1 -c "ping -c $INTENTS  $C2 | tee -a $SHAREDDIR/$DVM1/$VALIDA" 

vagrant ssh $S1 -c "ping -c $INTENTS  $S1.$DOMAIN | tee -a $SHAREDDIR/$DVM1/$VALIDA" 
vagrant ssh $S1 -c "ping -c $INTENTS  $S2.$DOMAIN | tee -a $SHAREDDIR/$DVM1/$VALIDA" 
vagrant ssh $S1 -c "ping -c $INTENTS  $C1.$DOMAIN | tee -a $SHAREDDIR/$DVM1/$VALIDA" 
vagrant ssh $S1 -c "ping -c $INTENTS  $C2.$DOMAIN | tee -a $SHAREDDIR/$DVM1/$VALIDA" 

vagrant ssh $S1 -c "dig $DOMAIN | tee -a $SHAREDDIR/$DVM1/$VALIDA" 

##########  mv2  - server 2

#recupera opcions globals
vagrant ssh $S2 -c "cp {$DIRBIND,$SHAREDDIR/$DVM2}/$GENERICCONF"
#recupera declaració de zona
vagrant ssh $S2 -c "cp {$DIRBIND,$SHAREDDIR/$DVM2}/$ZONEDEF"

#determinar els fitxers de zona (reciclem variables :) )
export AF1=$(grep file $DVM2/$ZONEDEF | grep -v "//" | tail -2 | head -1 | awk '{print $2}' | sed -r 's/"//g'| sed -r 's/;//g')
export AF2=$(grep file $DVM2/$ZONEDEF | grep -v "//" | tail -1 | head -1 | awk '{print $2}' | sed -r 's/"//g'| sed -r 's/;//g')
export RF1=$(echo $AF1 | sed -r 's/;//g' | sed -r 's/\// /g' | awk '{print $NF}')
export RF2=$(echo $AF2 | sed -r 's/;//g' | sed -r 's/\// /g' | awk '{print $NF}')

#recupera els fitxers de zona (són fitxers de dades)
vagrant ssh $S2 -c "cp $AF1 $SHAREDDIR/$DVM2/$RF1"
vagrant ssh $S2 -c "cp $AF2 $SHAREDDIR/$DVM2/$RF2"

# test connectivitat


##########  mv3  - client 1

#recupera fitxer resolv.conf
vagrant ssh $C1 -c "cp {$ARESOLV,$SHAREDDIR/$DVM3}/$RRESOLV"

# test connectivitat - el primer tee crea - la resta afegeix
vagrant ssh $C1 -c "ping -c $INTENTS  $S1 | tee    $SHAREDDIR/$DVM3/$VALIDA" 
vagrant ssh $C1 -c "ping -c $INTENTS  $S2 | tee -a $SHAREDDIR/$DVM3/$VALIDA" 
vagrant ssh $C1 -c "ping -c $INTENTS  $C1 | tee -a $SHAREDDIR/$DVM3/$VALIDA" 
vagrant ssh $C1 -c "ping -c $INTENTS  $C2 | tee -a $SHAREDDIR/$DVM3/$VALIDA" 

vagrant ssh $C1 -c "ping -c $INTENTS  $S1.$DOMAIN | tee -a $SHAREDDIR/$DVM3/$VALIDA" 
vagrant ssh $C1 -c "ping -c $INTENTS  $S2.$DOMAIN | tee -a $SHAREDDIR/$DVM3/$VALIDA" 
vagrant ssh $C1 -c "ping -c $INTENTS  $C1.$DOMAIN | tee -a $SHAREDDIR/$DVM3/$VALIDA" 
vagrant ssh $C1 -c "ping -c $INTENTS  $C2.$DOMAIN | tee -a $SHAREDDIR/$DVM3/$VALIDA" 

vagrant ssh $C1 -c "dig $DOMAIN | tee -a $SHAREDDIR/$DVM3/$VALIDA" 


##########  mv4  - client 2

#recupera fitxer resolv.conf
vagrant ssh $C2 -c "cp {$ARESOLV,$SHAREDDIR/$DVM4}/$RRESOLV"


# test connectivitat - el primer tee crea; la resta afegeix
vagrant ssh $C2 -c "ping -c $INTENTS  $S1 | tee    $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "ping -c $INTENTS  $S2 | tee -a $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "ping -c $INTENTS  $C1 | tee -a $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "ping -c $INTENTS  $C2 | tee -a $SHAREDDIR/$DVM4/$VALIDA" 

vagrant ssh $C2 -c "ping -c $INTENTS  $S1.$DOMAIN | tee -a $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "ping -c $INTENTS  $S2.$DOMAIN | tee -a $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "ping -c $INTENTS  $C1.$DOMAIN | tee -a $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "ping -c $INTENTS  $C2.$DOMAIN | tee -a $SHAREDDIR/$DVM4/$VALIDA" 

vagrant ssh $C2 -c "dig $DOMAIN | tee -a $SHAREDDIR/$DVM4/$VALIDA" 

# aturar el servidor principal i comprovar si continua funcionant
vagrant suspend $S1

vagrant ssh $C2 -c "ping -c $INTENTS  $C1 | tee -a $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "ping -c $INTENTS  $S2.$DOMAIN | tee -a $SHAREDDIR/$DVM4/$VALIDA" 
vagrant ssh $C2 -c "dig $DOMAIN | tee -a $SHAREDDIR/$DVM4/$VALIDA" 


## còpia de seguretat
cp Vagrantfile out
cp machines.yml out

tar cvzf puja_m_al_drive_$USER.tar.gz $DIRTMP
echo "ja pots pujar el fitxer puja_m_al_drive_$USER.tar.gz"

