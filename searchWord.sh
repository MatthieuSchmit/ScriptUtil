#!/bin/bash
#
# @author Matthieu Schmit - 12 janvier 2016
#
# Script cherchant un(e) mot(phrase) dans les fichier du dd
#


if [[ $(whoami) != "root" ]] ; then
        echo "Ce script doit être exécuté avec les droits root"
	echo "sudo $0"
	exit 1
fi

clear
echo "---SearchWord---"
echo
echo "Quel mot (ou phrase) chercher ?"
read name
echo "Dans quel répertoire ?"
read rep
echo
echo "Recherche de '$name' dans $rep"
echo
echo "...Patientez..."
echo "(peut prendre quelques minutes)"
echo

chemin=`find "$rep"  -print 2> /dev/null`

for i in $chemin ; do
	if [[ -f $i ]]; then
		grep $name $i 2> /dev/null >> .resultTemp
		if [ -s .resultTemp ] ; then
			echo $i >> .result
			rm .resultTemp
		fi
	fi
done

if [[ -e .result ]] ; then
	echo
	echo "Result :"
	echo "   '$name' se trouve dans :"
	echo
	cat .result
	rm .result
else
	echo
	echo "La recherche n'a rien donné"
	echo
fi



