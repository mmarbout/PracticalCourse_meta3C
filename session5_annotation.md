Session 5 : Annotation d'un assemblage

L'annotation d'un métagénome a deux objectifs principaux : i - caractériser les différents organismes (annotation taxonomique); ii - caractériser les différentes fonctions (annotation fonctionnelle), présentes dans l'échantillon. L’annotation peut se faire soit au niveau des séquences d'ADN obtenues (cf séance 2), soit au niveau des séquences protéiques putatives. L'utilisation des séquences d'ADN est plus précise mais plus difficile car les séquences d'ADN sont plus divergentes que les séquences protéiques. La première étape va donc consister à caractériser les ORFs putatives présentes dans notre assemblage.

vous avez récupéré votre assemblage qui contient des contigs renommés et sous cette forme:

NODE_XX_length_YY (length correspondant à la longueur du contig !!)

•	Recherche des phases ouvertes de lecture

Différents programmes existent pour rechercher de potentielles phases ouvertes de lecture (ORFs) (genemark, metagenemark, prodigal). Dans le cadre de ce TP nous utiliserons le programme prodigal qui est bien adapté aux métagénomes. Prodigal est un algorithme d'apprentissage automatique non supervisé (unsupervised machine learning). Il apprend de lui-même les propriétés du/des génome(s) à partir de la séquence elle-même, y compris le code génétique, l'utilisation du motif RBS (Ribosome Binding Site), l'utilisation du codon start ainsi que les statistiques d’utilisation des codons.

Prodigal s'utilise en ligne de commande avec les options suivantes :

o	 -a : fichier d'output où seront écrites les séquences de protéines putatives

o 	-p meta : pour les métagénomes

o 	-o : fichier d'output où seront écrites les données sur les ORFs détectées

o 	-d : fichier d'output où seront écrites les séquences des ORFs putatives (ADN)

o	 -i : fichier d'input

créer un répertoire de sortie

> mkdir  -p  annotations/prodigal/

lancer la recherche de phases ouvertes de lecture (25 min)

> prodigal -p meta -a annotations/prodigal/sampleXX_prot.fa -o annotations/prodigal/sampleXX.gene -d annotations/prodigal/sampleXX_gene.fa -i  assemblage/assembly_sampleXX.fa  >  log_files/prodigal.log  2>&1

Vous avez le droit à une bonne pause de 20 min le temps que Prodigal finisse son travail !!!

En vous servant des fichiers obtenus et de vos connaissances Unix (et du mémo fourni), répondez aux questions suivantes :

Qi15 : Combien de gènes putatifs détectez-vous ?

Qi16 : Quelle est la longueur moyenne des gènes détectés ?

Qi17 : Quel est le plus long gène détecté ?

Qi18 : Quel est la longueur totale des gènes détectés ?

Qi19 : Quelle est la densité en séquences codantes de votre assemblage ? cette valeur vous semble-t-elle cohérente ?

#############################################

Différents outils existent afin de caractériser les ORFs putatives présentes dans un assemblage (Principalement Blast ou HMM). Dans cette partie, nous allons rechercher des représentant de la famille des CrAss phages dans nos différents echantillons.

Concernant les bases de données de blast (protéiques ou nucléiques), elles peuvent être très générales (non-redundant nucleotide database sur NCBI) ou plus spécifiques de certains groupes ou familles de gènes (marqueurs taxonomiques, phages, gènes de résistance aux antibiotiques...). Il est également possible de réaliser soi-même sa base de données. Nous allons avec des base de données de deux protéines caractéristiques de la famille des crAss phages : La Polymérase et la Terminase.

création des index

> makeblastdb -in database/Crass_Polymerase.fa -input_type fasta -dbtype prot -out database/crass_pol > log_files/blastdb.log  2>&1

> makeblastdb -in database/Crass_Terminase.fa -input_type fasta -dbtype prot -out database/crass_ter > log_files/blastdb.log  2>&1

création des répertoires de sortie

> mkdir -p annotations/blast_output/ 

faire les blasts (8-10 min)

> blastp -db database/crass_pol -query annotations/prodigal/sampleXX_prot.fa -evalue 0.0001 -num_threads 4 -outfmt 6 -out annotations/blast_output/sampleXX_vs_crassPol.txt >  log_files/blast_crass_pol.log  2>&1

> blastp -db database/crass_ter -query annotations/prodigal/sampleXX_prot.fa -evalue 0.0001 -num_threads 4 -outfmt 6 -out annotations/blast_output/sampleXX_vs_crassTer.txt >  log_files/blast_crass_ter.log  2>&1

Qi20 : Combien de contigs candidats obtenez vous selon la séquence recherchée ? Quels sont les contigs qui vous paraissent les plus connvaincants et Pourquoi ? 

•	Recherche d'homologie par "hidden Markov model" (HMM)

Un modèle de Markov caché (HMM) est un modèle statistique qui permet de modéliser une séquence cible mais en autorisant un certain degré de variabilité. Les modèles de Markov cachés sont massivement utilisés notamment en reconnaissance de formes, en intelligence artificielle, en traitement automatique du langage naturel et également pour la détection de motifs protéiques. Différents modèles sont disponibles notamment sur la base de données "Pfam" (Protein family).
Nous allons travailler avec le logiciel hmmer qui s'utilise en ligne de commande. 

Nous allons commencer par construire un modèle HMM pour chacune des séquences recherchées. La première étape consiste à réaliser un alignement de nos séquuences avant de pouvoir construire le modèle.

copier le logiciel muscle

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/software/muscle_v5.0.1428_linux software/

donner les autorisations 

> chmod +x software/muscle_v5.0.1428_linux

lancer l'alignement (20 min) (vous pouvez aller voir un peu plus bas le paragraphe sur "les programmes spécifiques" en attendant.

> software/muscle_v5.0.1428_linux -quiet -in database/Crass_Polymerase.fa -out database/Crass_Polymerase_aln.fa

nettoyer les en-têtes de l'alignement

> cat database/Crass_Polymerase_aln.fa | sed 's/>/> /' | sed 's/_/ /g' | awk '{if ($1==">") print $1$2"_"$3"_"$4"_"$5; else print $0}' > database/Crass_Polymerase_aln_V2.fa

construire le modèle HMM

> hmmbuild database/Polymerase_crass.hmm database/Crass_Polymerase_aln_V2.fa

FAIRE LA MEME CHOSE AVEC LA TERMINASE

création du répertoire de sortie 

> mkdir -p annotations/hmm_output/

Pour le seuil de la recherche de motif, nous avons les deux options suivantes :

o	 -E : au niveau de la protéine entière

o 	--domE : au niveau des domaines protéiques

lancer la détection de motifs

> hmmsearch  -E  0.0001  --domE  0.0001  database/Polymerase_crass.hmm  annotations/prodigal/sampleXX_prot.fa  >  annotations/hmm_output/sampleXX_vs_crassPol.out

récupérer les séquences d'intérêt

> cat annotations/hmm_output/sampleXX_vs_crassPol.out  |  awk '{print $9}' |  grep  'NODE'  >  annotations/hmm_output/sampleXX_vs_crassPol.txt

FAIRE LA MEME CHOSE AVEC LA TERMINASE

Qi21 : Comme précédemment ... Combien de contigs candidats obtenez vous selon la séquence recherchée ? Quels sont les contigs qui vous paraissent les plus connvaincants et Pourquoi ? 

•	Programmes spécifiques

Il existe un grand nombre de programmes dédiés à la caractérisation de certains types d’éléments génétiques tel que les transposons, les plasmides, les phages. Ces programmes s’appuient généralement sur des séquences protéiques, des modèles HMM et d’autres spécificités des éléments étudiés pour caractériser des familles d’éléments bien spécifiques.

Recherches de gènes de type AMR : Resfinder ...

Recherches de phages : VIRSorter, VIBRANT ...

Recherches de plasmides : PlasmidFinder, Plasflow ...

Vous trouverez dans le dossier annotations/ les fichiers de sorties de différents programmes. Jetez y un oeil, vous pourrez en avoir besoin dans la suite du TP ...

copier les fichiers correspondants sur GAIA

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/annotations/Resfinder/Resfinder_sampleXX.txt annotations/

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/annotations/PlasFlow/PLASFLOW_sampleXX.tsv annotations/

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C//annotations/VIRSorter/VIRSORTER_sampleXX.csv annotations/

jetez un oeil sur le fichier de sortie du programme VIRSorter

Qi22 : Combien de contigs de phages candidats le programme VIRSorter détecte t il ? a quoi correspondent les catégories dans les fichiers de sorties du programme ?

Qi23: faites une comparaison des différents résultats obtenus !! Quels contigs garderiez vous pour la poursuite de l'analyse des CrAss phages dans nos échantillons ?

################# EXTRA ###################@

L'un des avantages de la technique de Meta3C est de pouvoir obtenir des matrices d'interactions de chaque contig de l'assemblage et donc d'étudier sa topologie. VirSorter, par exemple, indique si le contig détecté comme phage est circulaire.

copier le dossier scipts qui nous servira par la suite 

> scp -r votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/scripts ./

Par exemple, l'un des avantages de la technique de Meta3C est de pouvoir obtenir des matrices d'interactions de chaque contig de l'assemblage et donc d'étudier sa topologie. VirSorter, par exemple, indique si le contig détecté comme phage est circulaire.

Rechercher dans votre fichier "annotations/VIRSORTER_sampleXX.csv" le plus gros contig annoté comme circulaire de votre assemblage ou un contig candidat de la famille des CrAss phages

> cat annotations/VIRSORTER_sampleXX.csv | grep "circu" | awk -F "," '{print $1}' | sed 's/VIRSorter_//' | sed 's/-circular//' | sed 's/length_/length /g' | sort -k 2,2 -g -r | awk '{print $1"_"$2}' | head -1 

Une fois que vous connaissez ce contig, lancer le script contig_matrix_generation.sh qui prend 3 arguments en entrée [1-contig_target; 2-alignment_file; 3-output_directory]

vous trouverez le fichier alignement sur GAIA

> mkdir -p network/

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/network/alignment_sampleXX.txt network/

Mais avant de pouvoir utiliser ce script ... il va falloir installer quelques programmes et librairies !!

1- une librairie python permettant de téléchragre d'autres librairies python 

> curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
> python get-pip.py

2- des librairies python via la commande pip

> ~/.local/bin/pip3 install matplotlib Tk hicstuff

3- un package nécessaire via la commande apt-get

> sudo apt-get install python3-tk

maintenant ... vous pouvez lancer le script !!!

> bash scripts/contig_matrix_generation.sh NODE_XX_length_YY network/alignment_sampleXX.txt figure/

vous pourrez alors visualiser votre matrice et voir le signal circulaire (ou pas) dans le fichier d'ouput


