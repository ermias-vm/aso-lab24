#!/bin/bash

# Mostrar el proceso que más memoria consume y el porcentaje de memoria
ps -eo %mem,comm --sort=-%mem | head -n 2 | tail -n 1


    # -e: Muestra todos los procesos.
    # -o %mem,comm: Muestra solo dos columnas:
    #   %mem: El porcentaje de memoria que está utilizando el proceso.
        # comm: El nombre del comando o proceso.

# --sort=-%mem: Ordena los procesos por el uso de memoria de forma descendente (de mayor a menor).

# head -n 2: Muestra las dos primeras líneas. La primera línea es la cabecera con los nombres de las columnas y la segunda línea es el proceso que más memoria consume.

# tail -n 1: Seleciona la ultima linea 