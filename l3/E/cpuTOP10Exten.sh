#!/bin/bash

# Comprovem si s'ha passat un paràmetre, i si no, fixem el valor per defecte
NUM_PROCESSES=${1:-10}

# Llistat dels processos amb més temps de CPU, ordenats de més a menys
ps -eo pid,user,etime,comm --sort=-etime | head -n $((NUM_PROCESSES + 1))
