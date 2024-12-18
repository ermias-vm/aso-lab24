#!/bin/bash

SOURCE_DIR="/root"
DEST_DIR="/backup/rootBackup"

# Excludes file: list of files to exclude
EXCLUDES="/home/aso/Documentos/ASO/lab/l5/excludes"

# the name of the backup machine
BSERVER="localhost"

# put a date command for: year month day hour minute second
BACKUP_DATE=$(date +"%Y%m%d%H%M%S")

# options for rsync
OPTS="--ignore-errors --delete-excluded --exclude-from=$EXCLUDES \
--delete --backup --backup-dir=$DEST_DIR/$BACKUP_DATE -av"

# now the actual transfer
rsync $OPTS $SOURCE_DIR root@$BSERVER:$DEST_DIR/complet