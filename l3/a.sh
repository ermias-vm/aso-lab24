#!/bin/bash

# Función para calcular los días de inactividad desde la última sesión de un usuario
function calculate_inactive_days {
    user=$1

    # Extraer la última fecha de inicio de sesión utilizando lastlog
    lastlog_output=$(lastlog -u "$user" 2>/dev/null | grep "$user")
    
    # Si no se encuentra información de inicio de sesión, el usuario nunca ha iniciado sesión
    if [[ -z "$lastlog_output" || "$lastlog_output" =~ "Never logged in" ]]; then
        echo "El usuario $user nunca ha iniciado sesión en el sistema."
    else
        # Extraer la fecha de la última sesión
        lastlog_date=$(echo "$lastlog_output" | awk '{print $5, $6, $7}')
        
        # Convertir la fecha a formato timestamp (segundos desde la época Unix)
        lastlog_epoch=$(date -d "$lastlog_date" +%s 2>/dev/null)
        current_epoch=$(date +%s)

        # Calcular los días de inactividad
        days_inactive=$(( (current_epoch - lastlog_epoch) / 86400 ))

        # Mostrar la información calculada
        echo "El usuario $user tiene $days_inactive días inactivos desde su última sesión."
    fi
}

# Validar la entrada de parámetros
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <nombre_usuario>"
    exit 1
fi

# Llamar a la función para el usuario proporcionado como parámetro
calculate_inactive_days "$1"
