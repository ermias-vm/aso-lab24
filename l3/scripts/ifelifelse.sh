#!/bin/bash

if [ ${1,,} = ermias ]; then
	echo "Correct"
elif [ ${1,,} = help ]; then
	echo "Enter username"
else 
	echo "Who are you"
fi
