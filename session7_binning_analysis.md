session 7 : Analyse et validation des bins obtenus

Différentes approches permettent de valider les bins obtenus. Nous allons essayer de passer en revue différentes méthodes permettant de valider notre binning.

tout d'abord ... vous trouverez les données contig_data pour différentes itérations (contig_length_coverage_GCcontent_bin id _ bin size) sur l'espace GAIA

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/data_contigs/XX_contig_data_1it.txt  data_contigs/

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/data_contigs/XX_contig_data_100it.txt  data_contigs/

•	Marqueurs taxonomiques

Différents programmes existent afin de valider les bins obtenus après partitionnement d'un métagénome. Dans notre cas nous utiliserons checkM. La validation des bins avec ce programme consiste à rechercher un set de gènes bactériens (via des modèles HMM), essentiels et présents en une seule copie dans plus de 97% des génomes bactériens connus.

L’absence/présence et la multiplicité de ces marqueurs permettent ainsi d’évaluer : 

i - la complétude (mesure reliée au nombre de marqueurs au sein d'un bin par rapport au nombre attendu.

ii - la contamination (mesure reliée au nombre de marqueurs en plusieurs copies).

iii - l'hétérogénéité de souches (mesure reliée au nombre de marqueurs en plusieurs copies mais dont la séquence est proche).

Ce sont des calculs lourds qui ont été lancés sur le cluster de calcul de l'Institut Pasteur. Vous trouverez les résultats dans le dossier [checkM_output] qui contient différentes informations sur les bins identifiés.

CheckM génère différents fichiers :

- checkM_results_complete2_TP_XX_1it.txt : contient des données sur les génomes reconstruits 

- checkM_results_complete_TP_XX_1it.txt : contient des données sur les génomes reconstruit et les marqueurs taxonomiques utilisés pour évaluer les génomes

- TP_XX_1it1.txt: contient des données sur l'annotations taxonomique des génomes reconstruits

vous trouverez ces fichiers pour 1 itération de louvain (1it), 100 itérations (100it) 

créer un repertoire

> mkdir -p checkM_data/

copier les différents fichiers générés par checkM

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/checkM_data/*XX_1it.txt checkM_data/

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/checkM_data/*XX_100it.txt checkM_data/

Nous considèrerons un génome complet quand :

o	sa complétude se situe au-delà de 90%

o	sa contamination se situe en deçà de 10%

pour avoir cette information je vous conseille d'utiliser les fichiers checkM_results_complete2_TP_XX_1/100it.txt

Qi32 : Combien de génome(s) reconstruit(s) et complet(s) avez-vous ? après 1 itération ? après 100 itérations ?

Qi33 : A quoi peut être due la présence de bins contaminés même après 100 itérations ?

Qi34 : Avez-vous une idée de la manière d'améliorer le processus de binning ? bon en même temps la réponse est plus ou moins juste après ;)

Vous trouverez différents fichiers correspondant au binning final sur l’espace GAIA/ dans le dossier data_contigs/ et checkM_data/

> scp scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/data_contigs/XX_* data_contigs/

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/checkM_data/*XX_RE.txt checkM_data/

Étudiez l’évolution de vos bins (taille, complétion, contamination) au cours du processus de binning après 1 itération, 100 itérations et le processus recursif (RE) (exemple dans le polycopié)

•	Couverture et contenu en GC

Une autre façon de vérifier la qualité de nos bins est de regarder l’homogénéité de leur couverture et de leur contenu en GC. A l’aide du fichier contig_data.txt , générez différent boxplot des bin > 300 Kb (GC, coverage) (cf polycopié - p48 je crois)

Il est également possible de générer des « density plot » pour chaque bin afin de vérifier leur homogénéité.

lancement du script bin_analysis.sh qui prends 3 arguments en entrée [1-targeted_bin; 2-output_directory; 3-contig_data_file]

ATTENTION ICI !!!!  ne recopiez pas la ligne de commande betement !! il faut remplacer targeted bin par un bin que vous souhaitez étudier et le fichier contig_data par celui correspondant aux process en question ...

> bash scripts/bin_analysis.sh  targeted_bin  figure/  data_contigs/contig_data_XX.txt 

•	Matrices d’interactions

A partir de n'importe quel réseau ou fichier d’alignement, il est possible de générer une matrice qui est une méthode de visualisation de graphe.

Pour cela, nous allons utiliser le script bins_matrix_generation.sh écrit en bash et qui permet de recouper les différentes informations et de générer une matrice non réordonnée et une matrice réordonnée des contigs de l’assemblage :

usage du script : bash matrix_generation.sh  [fichier de sortie des données de louvain]  [fichier de l’alignement]  [dossier d’output]  [taille des pixels x 5Kb]

idem que au dessus concernant la ligne de commande !!!

vous êtes désormais (enfin j'espère) suffisamment à l'aise avec ces lignes de commandes et les arguments pour vous en sortir tout seul ;)

cela prend un peu de temps !! c'est une assez grosse matrice

vous pouvez faire cette matrice de tous les bins à différentes étpaes du process ... 1it / 100it etc ..

attention

lancement du script :

> bash scripts/bins_matrix_generation.sh  data_contigs/XX_contig_data_jesaispasquoi.txt  alignement/XX_alignment.txt  figure/  20

•	Arbres phylogénétiques

CheckM offre également la possibilité d’étudier le placement des bins étudiés dans « l’arbre de la vie ».

https://itol.embl.de/

Vous trouverez un dossier tree/ sur l'espace GAIA, il contient les différents fichiers permettant de générer les arbres phylogénétiques des bins correspondants à votre échantillon.Vous y trouverez également différent fichiers permettant d'annoter votre arbre.

si vous avez du temps ... allez y jeter un oeil !!! cela permet de faire des figures très jolies !!! 

on verra cela avec la correction ;)

