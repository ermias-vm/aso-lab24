#!/usr/bin/bash

# Verifica que se haya pasado un usuario como argumento

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <nombre_del_usuario>"
	exit 1
fi

USUARIO="$1"
BACKUP_DIR="/backups/users/$USUARIO"
FAILED_SHELL="/usr/local/bin/failed-login.sh"

# Verifica si sel usuario existe
#  se usa &>/dev/null para omitir redirigir la (stout y sterr) a /dev/null
if ! id "$USUARIO" &>/dev/null; then
	echo "EL usuario $USUARIO no existe."
	exit 1
fi

# Crear la carpeta de respaldo
echo "Creadndo respaldo en $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"


# Definir los directorios a excluir de la búsqueda (por ejemplo, /proc, /sys, /dev)
EXCLUDE_DIRS="-path /proc -prune -o -path /sys -prune -o -path /dev -prune -o -path /run -prune -o"

# Encuentra y copia todos los archivos del usuario 
echo "Realizando respaldo de archivos...."
sudo find / $EXCLUDE_DIRS -user "$USUARIO" -type f -print0 2>/dev/null | sudo xargs -0 cp -r -t "$BACKUP_DIR"

# Eliminar los archivos del usuario
echo "Eliminando archivos del usuario..."
sudo find / $EXCLUDE_DIRS -user "$USUARIO" -type f -print0 2>/dev/null | sudo xargs -0 rm -rf

# Cambiar el shell del usuario al script de desactivacion
echo  "Desactivando cuenta del usuario...."
sudo chsh -s "$FAILED_SHELL" "$USUARIO"


echo "El proceso de desactivacion para usuario : $USUARIO se ha completado."
