#!/bin/bash

# Commençons par récupérer les paramètres
file=`realpath $1`
option=$2
new_val=$3
echo -e "php.ini : $file\noption : $option\nnew value : $new_val"

#vérifier l'existence du fichier
e=`ls $file 2>&1`
if [ "$e" != "$file" ] 
then
	echo -e "Le fichier n'exsite pas, vérifiez son chemin"
	exit
fi
#vérifier l'option et sa valeur
o=`sed -ne "/^$option/p;/^;$option/p" $file | cat`
if [ "$o" != "" ]
then
	echo -e $o
	echo -e "A remplacer par : "
	n=`echo "$option = $new_val" | sed 's/\&/\\\&/g'`
	sed -ne "s/^$o$/$n/p" $file
	sed -e "s/^$o$/$n/" $file > ~/php.ini
	echo "Un fichier php.ini est crée à la racine de votre dossier home"
	read -p "Voulez-vous remplacer votre php.ini original ($file) ? (O/N)" rep

	if [ "$rep" != "" ]
	then
		if [ "$rep" == "O" ]
		then
			sudo cp -v ~/php.ini $file	
		elif [ "$rep" == "N" ]
		then
			echo "Ok, Ciao.. :p "
		else
			echo "Fausse réponse.... u_u "
		fi
	else
		echo "Wrong answer.... --'"
	fi
else
	echo "L'option n'existe pas"
fi
