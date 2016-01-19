#!/bin/bash

# @author Matthieu - 18 janvier 16
#
# Raccourci pour git add/commit/push
#
# Utilisation :
#	Ajouter au PATH le chemin absolu du script
#	Créer un alias pour plus de confort


echo "GitPush"
echo
read -p "Message du commit : " message
echo
echo "Addresse pour le push ?"
echo "a. ScriptUtil"
echo "      (https://github.com/MatthieuSchmit/ScriptUtil.git)"
echo "b. Arcade"
echo "      (https://github.com/timchapelle/ARCADE.git)"
echo "z. Autre"
read -n 1 adresse

case $adresse in
	"z"|"Z" )
		echo "Adresse ?"
		read adresse
		;;
	"a"|"A" )
		adresse="https://github.com/MatthieuSchmit/ScriptUtil.git"
		;;
	"b"|"B" )
		adresse="https://github.com/timchapelle/ARCADE.git"
		;;
	*)
		echo "Mauvais choix"
		exit 1
esac

git add *
git commit -m "$message"
git push $adresse