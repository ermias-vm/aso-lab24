#!/bin/bash

# Comprovem si s'ha passat un paràmetre
if [ -z "$1" ]; then
    # Si no s'ha passat paràmetre, utilitzem 10 per defecte
    NUM_PROCESSES=10
else
    # Si s'ha passat un paràmetre, comprovem si és un nombre vàlid
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        # Si és un nombre, assignem el valor
        NUM_PROCESSES=$1
    else
        # Si no és un nombre vàlid, mostrem un missatge d'error
        echo "Error: El paràmetre ha de ser un número enter positiu."
        exit 1
    fi
fi

# Llistat dels processos amb més temps de CPU, ordenats de més a menys
ps -eo pid,user,etime,comm --sort=-etime | head -n $((NUM_PROCESSES + 1))
