session 7 : Analyse et validation des bins obtenus

Différentes approches permettent de valider les bins obtenus. Nous allons essayer de passer en revue différentes méthodes permettant de valider notre binning.

vous trouverez les fichiers de sortie de notre pipeline MetaTOR sur l'espace GAIA

créer un répertoire de sortie

> mkdir -p output_MetaTOR/

copier les fichiers

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/output_MetaTOR/contig_data_final_XX.txt  output_MetaTOR/

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/output_MetaTOR/bin_summary_XX.txt  output_MetaTOR/

•	Marqueurs taxonomiques

Différents programmes existent afin de valider les bins obtenus après partitionnement d'un métagénome. Dans notre cas nous utiliserons checkM. La validation des bins avec ce programme consiste à rechercher un set de gènes bactériens (via des modèles HMM), essentiels et présents en une seule copie dans plus de 97% des génomes bactériens connus.

L’absence/présence et la multiplicité de ces marqueurs permettent ainsi d’évaluer : 

i - la complétude (mesure reliée au nombre de marqueurs au sein d'un bin par rapport au nombre attendu.

ii - la contamination (mesure reliée au nombre de marqueurs en plusieurs copies).

Ce sont des calculs lourds qui ont été lancés sur le cluster de calcul de l'Institut Pasteur. Vous trouverez les résultats dans le dossier [checkM_output] qui contient différentes informations sur les bins identifiés.

Les données concernant ces résultats sont contenues dans le fichier bin_summay

Nous considèrerons un génome complet quand :

o	sa complétude se situe au-delà de 90%

o	sa contamination se situe en deçà de 10%

Qi32 : Combien de génome(s) reconstruit(s) et complet(s) avez-vous ? 



Qi34 : Avez-vous une idée de la manière d'améliorer le processus de binning ? bon en même temps la réponse est plus ou moins juste après ;)


•	Couverture et contenu en GC

Une autre façon de vérifier la qualité de nos bins est de regarder l’homogénéité de leur couverture et de leur contenu en GC.

cf polycopié pour le graph à générer

Qi33 : graph du polycopié à essayer de reproduire

Il est également possible de générer des « density plot » pour chaque bin afin de vérifier leur homogénéité.

lancement du script bin_analysis.sh qui prends 3 arguments en entrée [1-targeted_bin; 2-output_directory; 3-contig_data_file]

ATTENTION ICI !!!!  ne recopiez pas la ligne de commande betement !! il faut remplacer targeted bin par un bin que vous souhaitez étudier et le fichier contig_data par celui correspondant aux process en question ...

> bash scripts/bin_analysis.sh  targeted_bin  figure/  data_contigs/contig_data_XX.txt 

•	Matrices d’interactions

A partir de n'importe quel réseau ou fichier d’alignement, il est possible de générer une matrice qui est une méthode de visualisation de graphe.

Pour cela, nous allons utiliser le script bins_matrix_generation.sh écrit en bash et qui permet de recouper les différentes informations et de générer une matrice non réordonnée et une matrice réordonnée des contigs de l’assemblage :

usage du script : bash bins_matrix_generation.sh  [fichier de sortie des données de louvain]  [fichier de l’alignement]  [dossier d’output]  [taille des pixels x 5Kb]

idem que au dessus concernant la ligne de commande !!!

vous êtes désormais (enfin j'espère) suffisamment à l'aise avec ces lignes de commandes et les arguments pour vous en sortir tout seul ;)

cela prend un peu de temps !! c'est une assez grosse matrice

attention

lancement du script :

> bash scripts/bins_matrix_generation.sh  data_contigs/XX_contig_data_jesaispasquoi.txt  alignement/XX_alignment.txt  figure/  20

•	Arbres phylogénétiques

CheckM offre également la possibilité d’étudier le placement des bins étudiés dans « l’arbre de la vie ».

https://itol.embl.de/

Vous trouverez un dossier tree/ sur l'espace GAIA, il contient les différents fichiers permettant de générer les arbres phylogénétiques des bins correspondants à votre échantillon.Vous y trouverez également différent fichiers permettant d'annoter votre arbre.

voici l'adresse

/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/tree

je vous laisse faire le scp ;)

attention c'est un dossier ... une petite option après le scp sera la bienvenue pour copier l'ensemble du dossier ;)

si vous avez du temps ... allez y jeter un oeil !!! cela permet de faire des figures très jolies !!! 

vous pouvez cliquer dans la barre du haut sur "upload"

vous chargez votre treefile [concat_XX.fa.treefile]

puis Upload 

et la c'est magique !! j'adore !!! 

ensuite vous pouvez directement faire des glisser de vos fichiers clas_treefile.txt, completion_trefile.txt .. etc sur la fenetre de votre arbre 

la correspondance couleur - taxo se trouve ici : /pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/taxo_color.txt

Les couleurs sont au format RGB (on les trouve sur internet ;)

vous verrez c'est chouette !!!

on verra cela avec la correction ;)

