#!/bin/bash

# Validación de parámetros
if [ $# -ne 1 ]; then
    echo "Uso: $0 <límite_espacio>"
    exit 1
fi

space_limit=$1

# Mensaje para agregar en el .bash_profile si el usuario excede el límite
warning_message="El uso de espacio en disco ha excedido el límite establecido. Por favor, elimina o comprime algunos archivos. Para eliminar este mensaje, borra la línea que contiene esta advertencia de tu .bash_profile."

# Convertir el límite de espacio introducido (K, M, G) a bytes
convert_space_to_bytes() {
    local size_str=$1
    if [[ "$size_str" == *K ]]; then
        echo $(( ${size_str%K} * 1024 ))
    elif [[ "$size_str" == *M ]]; then
        echo $(( ${size_str%M} * 1024 * 1024 ))
    elif [[ "$size_str" == *G ]]; then
        echo $(( ${size_str%G} * 1024 * 1024 * 1024 ))
    else
        echo "$size_str"
    fi
}
echo "Usuarios y su espacio utilizado en el sistema:"
echo "-----------------------------------------"

# Convertir el límite de espacio a bytes
space_limit_bytes=$(convert_space_to_bytes "$space_limit")

# Iterar sobre los usuarios para calcular su espacio utilizado
for user in $(cat /etc/passwdProva | cut -d: -f1); do
    home=$(cat /etc/passwdProva | grep "^$user:" | cut -d: -f6)

    if [ -d "$home" ]; then
        user_space=$(du -sh "$home" 2>/dev/null | cut -f1)
        user_space_bytes=$(du -sb "$home" 2>/dev/null | cut -f1)

        # Mostrar el espacio utilizado en la consola
        echo "$user uses $user_space"
        
        # Comparar el uso de espacio con el límite
        if [ "$user_space_bytes" -gt "$space_limit_bytes" ]; then
            echo "$warning_message" >> "$home/.bash_profile"
            echo "Mensaje agregado al .bash_profile de $user"
        fi
    fi
done