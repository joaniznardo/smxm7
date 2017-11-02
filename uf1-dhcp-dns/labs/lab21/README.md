# LAB 21 - dns - exemple de lab amb bind9

- [primera part](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-caching-or-forwarding-dns-server-on-ubuntu-16-04)
- [segona part](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-16-04)

- objectiu: poder fer ping entre les diferents màquines lab21vm{1,2,3,4} per nom (també per ip, clar)

  - configura un servidor de noms primari (cache i forwarding) i un de secundari per a la única xarxa assignada
    - lab21vm1 - dns1
    - lab21vm2 - dns2
    - lab21vm3 - client1
    - lab21vm4 - client2

  -nota: no cal canviar els noms de les màquines.

- recorda de substituir XXX, YYY i ZZZ pels valors assignats al fitxer de xarxes assignades a cada persona.

## sort

