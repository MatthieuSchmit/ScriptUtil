#!/bin/bash


# @author Matthieu Schmit
#
# Recherche un nom, et indique
#    - s'il existe sur le dd
#    - si c'est un fichier / repertoire
#    - ses permissions
#
# 13 janvier 2016
#   Script fonctionnant uniquement avec des options
#   Donne comme infos : permissions, propriétaire, dates ajout/modif, taille
#
# Utilisation :
#   Ajouter au PATH le chemin absolu du dossier du script
#   Créer un alias pour plus de confort


# Fonction lancée lors des erreurs d'entrée
FCT_Erreur () {
    echo "Erreur"
    echo "  -h for help"
    exit 1
}

# Fonction appelée pour chaque fichier/repertoire trouvé
FCT_Detail () {
for x in $opt ; do
        case $x in
            "r") FCT_Droits ;;
            "p") FCT_Proprio ;;
            "d") FCT_Date ;;
            "t") FCT_Taille ;;
        esac
done
}

# Fonction affichant la taille du fichier/repertoire
FCT_Taille () {
    taille=$(stat "$i" -c %s)
    echo "   Taille :"
    echo "      $taille bytes"
}

# Fonction affichant les date du fichier/repertoire
FCT_Date () {
    modif=$(stat "$i" -c %y)
    ajout=$(stat "$i" -c %w)
    echo "   Date d'ajout :"
    if [[ $ajout = "-" ]]; then
        echo "      inconnue"
    else
        echo "      $ajout"
    fi
    echo "   Date de la derniere modification :"
    if [[ $modif = "-" ]]; then
        echo "      inconnue"
    else
        echo "      $modif"
    fi
}

# Fonction affichant le propriétaire du fichier/repertoire
FCT_Proprio () {
    proprio=$(stat "$i" -c %U)
    echo "   Proprietaire :"
    echo "      $proprio"
}

# Fonction affichant les droits pour le fichier/repertoire
FCT_Droits () {
    echo "   Droits pour $USER :"
    if [ -r $i ] ; then
        echo "      Lecture autorisee"
    else
        echo "      Lecture non autorisee"
    fi
    if [ -w $i ] ; then
        echo "      Ecriture autorisee"
    else
        echo "      Ecriture non autorisee"
    fi
    if [ -x $i ] ; then
        echo "      Execution autorisee"
    else
        echo "      Execution non autorisee"
    fi
}

# Fonctions cherchant tout fichier/repertoire contenant le mot passé en paramètre
FCT_Recherche () {
    echo
    echo "Patientez..."
    echo
    chemin=`find / -name "$file" -print 2>/dev/null`
    echo
    if [[ $chemin ]] ; then
        echo "Resultat"
        echo
        for i in $chemin; do
            echo $i
            FCT_Detail
            echo
        done
        echo "done."
        exit 0
    else
        echo "Erreur. $result n'existe pas"
    fi
}

# Fonction appelée avec l'option -h
FCT_Help () {
    echo "Name :"
    echo "  search.sh"
    echo
    echo "Emplacement :"
    echo "  $0"
    echo
    echo "Description"
    echo "   search.sh cherche tous les fichiers/repertoires suivant"
    echo "  un nom donné. Et en affiche les droits, le proprietaire, les dates d'ajout"
    echo "  et de modification et la taille."
    echo
    echo "Utilisation :"
    echo "  searchPerm.sh [-option] <nom>"
    echo
    echo "Options :"
    echo "  [-r] : droits"
    echo "  [-p] : proprietaire"
    echo "  [-d] : dates"
    echo "  [-t] : taille (en bytes)"
    echo "  [-a] : tout"
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

opt=""
while getopts "r:p:d:t:a:" option ; do
    case $option in
        r)  opt=$opt"r "
            file=$2 ;;
        p)  opt=$opt"p "
            file=$2 ;;
        d)  opt=$opt"d "
            file=$2 ;;
        t)  opt=$opt"t "
            file=$2 ;;
        a)  opt="r p d t"
            file=$OPTARG
            FCT_Recherche ;;
        *)  FCT_Erreur ;;
    esac
done

FCT_Recherche
