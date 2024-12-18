#!/bin/bash

# Llistat dels 10 processos amb més temps de CPU, ordenats de més a menys
ps -eo pid,user,etime,comm --sort=-etime | head -n 11


#ps -eo pid,user,etime,comm:

    #ps: Mostra informació sobre els processos en execució.
    #-e: Mostra tots els processos.
    # -o pid,user,etime,comm: Aquests són els camps que es volen mostrar:
        # pid: ID del procés.
        # user: Usuari propietari del procés.
        # etime: Temps acumulat de CPU (en format [[dd-]hh:]mm:ss).
        # comm: Nom de l'executable del procés.

# --sort=-etime: Ordena els processos per temps acumulat de CPU (etime), de més a menys, gràcies al signe - abans de etime.

# head -n 11: Mostra només les 11 primeres línies (la primera línia és el capçalera de la comanda ps, així que només mostrarem 10 processos)