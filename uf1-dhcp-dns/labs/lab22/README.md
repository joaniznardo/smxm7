# LAB 22 - dns - laboratori validació dns

- [seguint i adaptant les instruccions de...](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-16-04)

- objectiu: poder fer ping entre les diferents màquines lab22vm{1,2,3,4} per nom (també per ip, clar)

  - configura un servidor de noms primari (cache i forwarding) i un de secundari per a la única xarxa assignada
    - lab22vm1 - dns1
    - lab22vm2 - dns2
    - lab22vm3 - client1
    - lab22vm4 - client2

  - el nom del domini serà <lab22.inicial_nom+cognom1.org>
  - ex: en el meu cas seria: lab22.jiznardo.org  
  
  - nota: canvia els noms de les màquines si ho necessites ;) (machines.xml).

- recorda de substituir XXX pel valor assignat al fitxer de xarxes assignades a cada persona.

## sort

