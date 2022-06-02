# Session 5 : analyse 3D des contigs

L'un des avantages de la technique de Meta3C est de pouvoir obtenir des matrices d'interactions de chaque contig de l'assemblage. Cela peut servir pour certaine vérification, pour analyser des prophages ou encore étudier la topologie de certaines molécules d'ADN. VirSorter, par exemple, indique si le contig détecté comme phage est circulaire.

on va commencer par regarder la matrice du contig (de plus de 100 kb) le plus couvert:

```sh
mkdir  -p  annotations/prodigal/
```

cat /pasteur/zeus/projets/p02/rsg_fast/Martial/projets/test_TP/contig_data_network.txt | sed '1d' | awk '$3>=100000 {print $2,$5/$3}' | sort -k 2,2 -g -r | head

> cat annotations/VIRSORTER_sampleXX.csv | grep "circu" | awk -F "," '{print $1}' | sed 's/VIRSorter_//' | sed 's/-circular//' | sed 's/length_/length /g' | sort -k 2,2 -g -r | awk '{print $1"_"$2}' | head -1 

Une fois que vous connaissez ce contig, lancer le script contig_matrix_generation.sh qui prend 3 arguments en entrée [1-contig_target; 2-alignment_file; 3-output_directory]

vous trouverez le fichier alignement sur GAIA

> mkdir -p network/

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/network/alignment_sampleXX.txt network/

Mais avant de pouvoir utiliser ce script ... il va falloir installer quelques programmes et librairies !!

1- une librairie python permettant de télécharger d'autres librairies python 

> curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
> python get-pip.py

2- des librairies python via la commande pip

> ~/.local/bin/pip3 install matplotlib Tk hicstuff

3- un package nécessaire via la commande apt-get

> sudo apt-get install python3-tk

maintenant ... vous pouvez lancer le script !!!

> bash scripts/contig_matrix_generation.sh NODE_XX_length_YY network/alignment_sampleXX.txt figure/

vous pourrez alors visualiser votre matrice et voir le signal circulaire (ou pas) dans le fichier d'ouput


