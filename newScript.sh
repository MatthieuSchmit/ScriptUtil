#!/bin/bash

# @author Matthieu Schmit - 7 janvier 2016
#
# Crée des scripts .sh avec les permissions d'exécution
#
# 13 janvier 2016
#   Script fonctionnant uniquement avec des options
#
# Utilisation :
#   Ajouter au PATH le chemin absolu du dossier du script
#   Créer un alias pour plus de confort
#
#
#
#
#   !!!! LINUX USER !!!!
# ligne 97 à supprimer. Ecrite pour Mac OSX
#
#
#   !!!! MAC OSX USER !!!!
# ligne 97 à supprimer (ou SublimeText2 à installer)


# nFonction lancée lors des erreurs d'entrée
FCT_Erreur () {
    echo "Error."
    echo " -h for help"
    exit 1
}

# Fonction appelée avec l'option -h
FCT_Help () {
    echo "Name :"
    echo "  newScript.sh"
    echo
    echo "Emplacement :"
    echo "  $0"
    echo
    echo "Description"
    echo "  newScript.sh permet de créer facilement de nouveaux scripts .sh exécutables"
    echo
    echo "Utilisation :"
    echo "  newScript.sh [-n] <numeroScript>"
    echo "  newScript.sh [-N] <nomScript> (sans le .sh)"
    echo
    echo "Modification :"
    echo "  Uniquement en tant que root"
    exit 0
}

# Vérification si bien deux arguments et si le premier est une option
var=$1
var=${var:0:1}
if [[ $# -ne 2 ]] || [[ $var != "-" ]]; then
    if [[ $# -eq 1 ]] && [[ $1 = "-h" || $1 = "-H" ]]; then
        FCT_Help
    fi
    FCT_Erreur
fi


while getopts "n:N:" opt; do
    case $opt in
        n)  nom="script"$OPTARG".sh"
            ;;
        N)  nom=$OPTARG".sh"
            ;;
        *)  FCT_Erreur
    esac
done


# Vérifie si un script du même nom existe déjà dans le répertoire courant
chemin=`find $pwd"$nom" 2> /dev/null`
while [ $chemin ] ; do
    echo "$nom existe déjà."
    echo "Nouveau nom ?  (ne pas écrire l'extension .sh)"
    read nom
    nom=$nom".sh"
    chemin=`find $pwd"$nom" 2> /dev/null`
done

# Création du .sh
touch $nom
chmod +x $nom
echo "$nom a bien été créé"

# Rempli l'en-tete du .sh
echo "#!/bin/bash" >> $nom
echo >> $nom
echo "# @author "`whoami`" - "`date +"%d %B %y"` >> $nom
echo "#" >> $nom
echo "# $nom" >> $nom

# Ouvre le script créé avec SublimeText (mac OSX)
open /Applications/Sublime\ Text\ 2.app/ $nom



