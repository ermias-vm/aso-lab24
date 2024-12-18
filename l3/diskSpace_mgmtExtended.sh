#!/bin/bash

# Validación de parámetros
if [ $# -lt 1 ] || [ $# -gt 3 ]; then
    echo "Uso: $0 [-g grupo] <límite_espacio>"
    exit 1
fi

# Inicialización de variables
group=""
space_limit=""

# Procesamiento de parámetros
while [ $# -gt 0 ]; do
    case $1 in
        "-g")
            if [ -n "$2" ]; then
                group=$2
                shift 2
            else
                echo "Error: falta el nombre del grupo tras la opción -g"
                exit 1
            fi
            ;;
        *)
            space_limit=$1
            shift
            ;;
    esac
done

if [ -z "$space_limit" ]; then
    echo "Error: no se especificó el límite de espacio"
    exit 1
fi

# Convertir el límite de espacio a bytes
convert_to_bytes() {
    local size_str=$1
    if [[ "$size_str" =~ ([0-9]+)([KMG]) ]]; then
        local value=${BASH_REMATCH[1]}
        local unit=${BASH_REMATCH[2]}
        case "$unit" in
            K) echo $((value * 1024)) ;;
            M) echo $((value * 1024 * 1024)) ;;
            G) echo $((value * 1024 * 1024 * 1024)) ;;
        esac
    else
        echo "$size_str"
    fi
}

space_limit_bytes=$(convert_to_bytes "$space_limit")

# Mensaje para agregar en el .bash_profile si el usuario excede el límite
warning_message="El uso de espacio en disco ha excedido el límite establecido. Por favor, elimina o comprime algunos archivos. Para eliminar este mensaje, borra la línea que contiene esta advertencia de tu .bash_profile."

# Función para calcular el uso de disco
calculate_usage() {
    local user=$1
    local home=$2

    if [ -d "$home" ]; then
        user_space_bytes=$(du -sb "$home" 2>/dev/null | cut -f1)
        user_space=$(du -sh "$home" 2>/dev/null | cut -f1)

        echo "$user uses $user_space"

        if [ "$user_space_bytes" -gt "$space_limit_bytes" ]; then
            echo "$warning_message" >> "$home/.bash_profile"
            echo "Mensaje agregado al .bash_profile de $user"
        fi

        echo $user_space_bytes
    else
        echo 0
    fi
}

# Procesar usuarios según los parámetros
if [ -n "$group" ]; then
    # Obtener usuarios del grupo
    group_users=$(getent group "$group" | cut -d: -f4 | tr ',' ' ')
    if [ -z "$group_users" ]; then
        echo "El grupo '$group' no existe o no tiene usuarios."
        exit 1
    fi

    total_group_usage=0
    echo "Usuarios y su espacio utilizado en el grupo '$group':"
    echo "-----------------------------------------"

    for user in $group_users; do
        home=$(getent passwd "$user" | cut -d: -f6)
        user_usage=$(calculate_usage "$user" "$home")
        total_group_usage=$((total_group_usage + user_usage))
    done

    echo "-----------------------------------------"
    echo "Total disk usage for group '$group': $(numfmt --to=iec $total_group_usage)"
else
    # Procesar todos los usuarios del sistema
    echo "Usuarios y su espacio utilizado en el sistema:"
    echo "-----------------------------------------"

    while IFS=: read -r user _ _ _ _ home _; do
        calculate_usage "$user" "$home" >/dev/null
    done < /etc/passwd
fi