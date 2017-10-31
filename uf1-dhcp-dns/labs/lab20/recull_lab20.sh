#!/bin/bash

##
## 
##
##

# efectuem la "triangulació de pings..." per comprovar
vagrant ssh lab18vm1 -c "ping -c 3 lab20vm2 "
vagrant ssh lab18vm2 -c "ping -c 3 lab20vm3 "
vagrant ssh lab18vm3 -c "ping -c 3 lab20vm1 "
