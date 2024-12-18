#!/bin/bash


case ${1,,} in 
	ermias | administrator)
		echo "Hello, you're the boss here!"
		;;
	help)
		echo "Just Enter your username!"
		;;
	*)
		echo "Hello ther. Youre not the boss of me"
esac
