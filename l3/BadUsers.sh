#!/bin/bash
p=0

function print_help
{
    echo "Usage: $1 [options]"
    echo "Possible options:"
    echo "-p validate users with running process"
}

if [ $# -gt 1 ]; then
    print_help $0
    exit
fi

while [ $# -gt 0 ]; do
    case $1 in
        "-p")
            p=1
            shift;;
        *) 
            echo "Error: not valid option: $1"
            exit 1;;
    esac
done

for user in $(cat /etc/passwd | cut -d: -f1); do
    home=$(cat /etc/passwd | grep "^$user:" | cut -d: -f6)
    if [ -d "$home" ]; then
        num_fich=$(find "$home" -type f -user "$user" 2>/dev/null | wc -l)
    else
        num_fich=0
    fi

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
done




if [ -z]