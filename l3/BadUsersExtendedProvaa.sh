#!/bin/bash
p=0
inactive_days=""

# Función para mostrar la ayuda
function print_help
{
    echo "Usage: $1 [options]"
    echo "Possible options:"
    echo "-p validate users with running process"
    echo "-t <time> detect inactive users. Example: -t 2d (2 days), -t 4m (4 months)"
}

# Validación de parámetros iniciales
if [ $# -gt 2 ]; then
    print_help $0
    exit
fi

# Procesamiento de parámetros
while [ $# -gt 0 ]; do
    case $1 in
        "-p")
            p=1
            shift;;
        "-t")
            if [ -n "$2" ]; then
                inactive_time=$2
                shift 2
            else
                echo "Error: missing value for -t option"
                exit 1
            fi
            ;;
        *)
            echo "Error: not valid option: $1"
            exit 1;;
    esac
done

# Depurar la entrada del parámetro
echo "Inactive time parameter passed: '$inactive_time'"

# Convertir el tiempo de inactividad a días numéricos si se especificó
if [[ -n "$inactive_time" ]]; then
    if [[ "$inactive_time" =~ ([0-9]+)d$ ]]; then
        # Caso: Xd (días)
        inactive_days=$(echo "$inactive_time" | sed 's/d//')
    elif [[ "$inactive_time" =~ ([0-9]+)m$ ]]; then
        # Caso: Xm (meses) -> convertir a días
        months=$(echo "$inactive_time" | sed 's/m//')
        inactive_days=$((months * 30)) # Conversión aproximada de meses a días
    else
        echo "Error: Invalid time format. Use Xd (days) or Xm (months)."
        exit 1
    fi
fi

# Mostrar el número de días calculado para depurar
echo "Converted inactive days: $inactive_days"

# Detectar usuarios en el sistema
for user in $(cat /etc/passwdProva | cut -d: -f1); do
    home=$(cat /etc/passwdProva | grep "^$user:" | cut -d: -f6)

    # Contar archivos de usuario
    if [ -d "$home" ]; then
        num_fich=$(find "$home" -type f -user "$user" 2>/dev/null | wc -l)
    else
        num_fich=0
    fi

    # Validar usuarios sin archivos
    if [ $num_fich -eq 0 ]; then
        if [ $p -eq 1 ]; then
            user_proc=$(ps -u "$user" --no-headers 2>/dev/null | wc -l)
            if [ $user_proc -eq 0 ]; then
                echo "The user $user has no processes"
            fi
        else
            echo "The user $user has no files in $home"
        fi
    fi

    # Validación de usuarios inactivos solo si el parámetro -t fue pasado
    if [ -n "$inactive_days" ]; then
        # Comprobar el último inicio de sesión del usuario
        lastlog_output=$(lastlog -u "$user" 2>/dev/null)
        if echo "$lastlog_output" | grep -q "Never logged in"; then
            echo "The user $user has never logged in."
        else
            lastlog_date=$(echo "$lastlog_output" | awk '{print $4, $5, $6}')
            lastlog_epoch=$(date -d "$lastlog_date" +%s 2>/dev/null)
            current_epoch=$(date +%s)
            days_inactive=$(( (current_epoch - lastlog_epoch) / 86400 ))

            # Comparar con el período de inactividad ingresado
            if [[ $days_inactive -gt $inactive_days ]]; then
                echo "User $user is inactive for more than $inactive_days days"
            fi
        fi
    fi
done

