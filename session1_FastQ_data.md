Session 1: Contrôle qualité et traitement des séquences brutes issues du séquençage

Vous allez travailler avec 4 fichiers de sorties de séquençage : les reads en sens (forward) et en anti-sens (reverse) pour chaque banque construites (ShotGun et 3C). Vos fichiers sont nommés ainsi et se trouve sur l'espace GAIA:

sampleX_SG_for.fastq.gz

sampleX_SG_rev.fastq.gz

sampleX_3C_for.fastq.gz

sampleX_3C_rev.fastq.gz

Avant de procéder à l'analyse ou à l'exploitation d'un ensemble de données de séquençage, il est impératif de réaliser des contrôles de qualité des séquences brutes et d'appliquer des filtres si nécessaires. Cette opération permettra de s'assurer qu'il n'y a pas de problèmes cachés dans vos données initiales et de travailler avec des séquences de bonne qualité.

se placer sur le bureau de la Machine virtuelle

> cd ~/Bureau/

créer un répertoire (l'option -p permet de créer des répertoires dans des répertoires n'existant pas et évite les messages d'erreurs ... c'est parfois utile et c'est un réflexe chez moi))

> mkdir -p TP_Meta3C/

rentrer dans le repertoire

> cd  TP_Meta3C/

toutes les lignes de commande que vous verrez s'exécuteront depuis cet emplacement désormais !!!!

créer un répertoire pour y déposer les fichiers fastq

> mkdir -p fastq/
 
choisissez au hasard parmi les 10 échantillons et copier les fichiers fastq correspondants (n'oubliez pas de changer le X !!!)

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/FastQ/sampleX_* fastq/

pour cette séance vous aurez également besoin d'un fichier fasta contenant les séquences des adaptateurs illumina. Copier l'ensemble du dossier fasta sur GAIA qui contient d'autre fichiers dont nous aurons besoin par la suite.

> scp -r votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/fasta/ ./

visualiser vos données fastq 

> zcat  fastq/sampleX_SG_for.fastq.gz  |  head

> zcat  fastq/sampleX_SG_rev.fastq.gz  |  head

> zcat  fastq/sampleX_SG_for.fastq.gz  |  head

> zcat  fastq/sampleX_3C_rev.fastq.gz  |  head


Qi1 : Combien de lignes un read occupe-t-il ?

Qi2 : A quoi correspond chaque ligne ?

Qi3 : Combien de reads forward et reverse avez-vous dans vos jeux de données ?

Qi4 : Quelle est la longueur des reads (SG et 3C) ?

Qi5 : Quels "Tags" sont associés à vos librairies ?

Qi6 : Quelles différences observez-vous entre les Reads SG et les Reads 3C ?


1- Contrôle qualité des reads (fichier FastQ)

fastQC est un programme qui prend comme entrée un fichier FastQ et exécute une série de tests pour générer un rapport complet sur la qualité des reads et des bases à différentes positions. Le programme s’exécute en ligne de commande avec les options suivantes :

o 	-t : nombre de processeurs accordé au programme

o 	-o : répertoire de sortie

o 	--nogroup : option permettant d’avoir des graphiques pour chaque base et non par groupe de 5

créer un répertoire de sortie des rapports de qualité des lectures

> mkdir  -p  fastq/rapport_qualite/

créer un répertoire de sortie des fichiers log

> mkdir  -p  log_files/

lancer le programme FastQC

> ~/Bureau/install/FastQC/fastqc  -t  4  --nogroup  -o  fastq/rapport_qualite/  fastq/sampleX_SG_for.fastq.gz  >  log_files/fastqc_raw_SG_for.log 2>&1

> ~/Bureau/install/FastQC/fastqc  -t  4  --nogroup  -o  fastq/rapport_qualite/  fastq/sampleX_3C_for.fastq.gz  >  log_files/fastqc_raw_3C_for.log 2>&1

Vous trouverez les données générées par fastQC dans le dossier [fastq/rapport_qualite/sampleX_raw_SG_for_fastqc]. Afin d'avoir accès à différentes statistiques concernant vos reads, ouvrir le fichier [fastqc_report.html] (par double clic). Ne prenez pas en compte la partie "Kmer content" qui est sujette à controverse notamment en ce qui concerne des reads issues d'un métagénome.

faire la même chose pour les reads reverse

on aurait également pu écrire une petite boucle pour faire tout cela (il y a un léger bugg avec github ici)

> for sens in for rev

> do 

> for type in SG 3C

> do

> ~/Bureau/install/FastQC/fastqc  -t  4  --nogroup  -o  fastq/rapport_qualite/  fastq/sampleX_"$type"_"$sens".fastq.gz  >  log_files/fastqc_raw_"$type"_"$sens".log 2>&1

> done

> done

Qi7 : En analysant le rapport de qualité Quelle est l’enzyme que vous avez utilisée pour faire votre banque 3C ?

•	Cutadapt : détection et retrait des séquences d’adaptateurs

cutadapt est un programme permettant de rechercher des séquences d’adaptateurs à l'intérieur des reads brutes afin de les retirer car elles peuvent provoquer des problèmes au moment de l'assemblage. Il permet également de filtrer les reads afin de retirer du jeu de données ceux de mauvaise qualité et/ou trop petits. Le programme s’exécute en ligne de commande avec les options suivantes :

o	 -a file : fichier contenant les séquences des adaptateurs forward

o 	-A file : fichier contenant les séquences des adaptateurs reverse

o 	-o : fichier de sortie FastQ forward

o 	-p : fichier de sortie FastQ reverse

o 	-q : option permettant de définir une qualité minimale

o 	-m : option permettant de définir une longueur minimale des reads

NB : Dans le dossier [fasta/] sur l'espace GAIA vous trouverez le fichier contenant les séquences des adaptateurs que nous utilisons au laboratoire.

supprimer les séquences des adaptateurs

> cutadapt  -q 20  -m  45  -a  file:fasta/adaptateur.fasta  -A  file:fasta/adaptateur.fasta  -o  fastq/sampleX_filtre_SG_for.fastq.gz  -p  fastq/sampleX_filtre_SG_rev.fastq.gz  fastq/sampleX_SG_for.fastq.gz  fastq/sampleX_SG_rev.fastq.gz  >  log_files/cutadapt_SG.log  2>&1

Petite pause peut être ? c'est un poil long ...

refaire l’analyse FastQC

> ~/Bureau/install/FastQC/fastqc  -t  4  --nogroup  -o  fastq/rapport_qualite/  fastq/sampleX_filtre_SG_for.fastq.gz  >  log_files/fastqc_filter_SG_for.log 2>&1

Qi8 : Combien de reads avez-vous gardé après cette étape de filtration ? En quoi votre jeu de données est-il différent ?

Refaire la même chose pour les reads 3C.

idem on aurait pu faire une petite boucle ;)

Si vous n'avez gardé aucun reads 3C ... savez vous pourquoi ? et comment corriger cela ?

Vous avez maintenant un jeux de données permettant de poursuivre l'analyse.







