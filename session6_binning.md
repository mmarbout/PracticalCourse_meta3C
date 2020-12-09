Session 6 : Binning des contigs par exploitation des interactions inter-contigs

La métagénomique permet aujourd'hui d'étudier les micro-organismes non cultivables et ainsi d'appréhender le fonctionnement biologique de tout type d'écosystème. Néanmoins, le séquençage massif ne permet pas un inventaire exhaustif des micro-organismes et encore moins de relier la structure de la communauté et les fonctions biologiques qu'elle assure. Pour pallier cela, il est nécessaire de reconstruire les génomes complets des populations présentes. Cependant, la faible taille des séquences générées associée à la grande diversité des espèces rend l'assemblage des séquences très compliqué. Plusieurs stratégies ont été développées pour tenter de reconstruire des génomes à partir de données métagénomiques, notamment par l'utilisation du binning (cf introduction). Ces méthodes consistent à établir le profil des fragments de génomes selon leur composition en nucléotides et/ou leur abondance au sein d'un ou plusieurs métagénomes. Deux contigs aux profils similaires appartiendraient ainsi au génome d'un même organisme. La technique de Meta3C utilise, elle, les fréquences de collision entre molécules d'ADN, et donc la proximité spatiale des molécules pour regrouper les contigs au sein de "communautés". 

•	Génération du réseau d’interactions inter-contig

La première étape va consister à aligner les paires de lectures sur l’assemblage global afin d'établir un réseau d'interactions entre les contigs de l’assemblage. Ce réseau nous servira ensuite au regroupement (binning) des contigs. Le script a déjà été lancé avec l’ensemble des données fastq afin de générer un réseau d’interaction global contenant l’ensemble des expériences pour les 2 échantillons.

Si vous souhaitez voir le script, vous le trouverez dans le répertoire [scripts/]

usage du script : bash network_generation.sh  [repertoire de sortie]  [fichier d’assemblage]  [fichiers FastQ_for]  [fichiers FastQ_rev]  [Mapping_Quality_Threshold]

Les données générées par ce script se trouve sur GAIA. Copier le dossier correspondant à votre échantillon dans votre dossier et décompresser le. Ce dossier contient différents répertoires contenants chacun différents fichiers.

> mkdir -p network/

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/network/XX_* network/

vous aurez aussi besoin d'un fichier contenant les données des contigs

> mkdir -p data_contigs/

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/data_contigs/idx_contig_length_cov_GC_XX.txt data_contigs/

explorer le répertoire network

> ls  -l  network/

fichier=XX_network.txt (col1: contig1 (nœud1) / col2: contig2 (noeud2) / col3: score)

fichier=XX_network_raw.txt (col1: contig1 (nœud1) / col2: contig2 (noeud2) / col3: score)

fichier=XX_network_norm.txt (col1: contig1 (nœud1) / col2: contig2 (noeud2) / col3: score normalisé)


Qi21 : Quelles sont les différences entre les différents fichiers Network ?

Qi22 : Combien de nœuds contient votre réseau global ?

Qi23 : Combien de liens différents contient-il (c-a-d entre 2 contigs, sans tenir compte du poids de ces liens) ?

Qi24 : Combien de liens au total contient-il ?


•	Algorithme de Louvain

La plupart des graphes de terrains (type de graphe mathématiques) exhibent une structure communautaire. Une communauté se définit comme un sous-graphe composé de nœuds densément reliés entre eux et faiblement liés aux autres nœuds du graphe. La méthode Meta3C est basée sur cette notion et le fait que deux séquences d'ADN appartenant à un même compartiment cellulaire auront plus fréquemment des interactions que deux séquences appartenant à deux compartiments différents. Pour la détection des "communautés de contigs" (i.e. des groupes de contigs ou bins) nous utiliserons l'algorithme de Louvain. C'est un algorithme hiérarchique qui itère sur deux étapes : 

i - Il cherche les petites communautés en optimisant la modularité de Newman et Girvan d'une manière locale. 

ii - Il fusionne les nœuds de la même communauté et construit un nouveau réseau dont les nœuds sont les communautés. La partition qui a le maximum de modularité est retenue.

Une modularité est une mesure de la qualité d'une partition des sommets (les noeuds) d'un graphe. Le principe est qu'un bon partitionnement d'un graphe implique un nombre d'arêtes (de liens) intra-communautaires important et un nombre d'arêtes intercommunautaires faible.

•	Détection de communautés par l'algorithme de Louvain

création d’un répertoire de sortie

> mkdir  -p  binning/

conversion d'un fichier texte en fichier binaire utilisable par l’algorithme de Louvain

> ~/Bureau/install/louvain/convert_net  -i  network/XX_network_norm.txt  -o  binning/net.bin  -w  binning/net.weights

calcul des communautés et rendu d'un arbre hiérarchique

> ~/Bureau/install/louvain/louvain binning/net.bin  -l  -1  -w binning/net.weights  >  binning/net.tree

calcul des informations concernant l'arbre hiérarchique (nb de niveau et nb de communautés par niveau)

> ~/Bureau/install/louvain/hierarchy  binning/net.tree  >  binning/level_louvain.txt

rendu de l'appartenance d'un nœud à une communauté pour un niveau hiérarchique donné
NB : nous travaillons toujours avec le dernier niveau. C'est à vous de le déterminer en fonction du fichier "level_louvain.txt"

donc NE ME METTEZ PAS UNE LIGNE DE COMMANDE AVEC UN "?" !!!!!!!

explorez le fichier level.txt

> cat binning/level_louvain.txt

quel level devez vous prendre ? il s'agit de son indice qu'il faut mettre !!! 

> ~/Bureau/install/louvain/hierarchy  binning/net.tree  -l  ?  >  binning/output_louvain.txt

Le fichier obtenu comprend dans la colonne 1 l'indice du contig et dans la colonne 2 l'indice de la communauté. 
A partir de ce fichier et du fichier contenant les données des contigs (taille, couverture, contenu en GC), on peut générer tout un ensemble de données sur les communautés ou « bins » déterminés par l’algorithme de louvain. Pour cela, nous allons utiliser le script louvain_data_treatment écrit en bash et qui permet de recouper les différentes informations et de générer divers fichiers :

-	contig_data.txt : contig – length – coverage – GC content – bin id – bin size 
-	bin_data: bin – bin size

usage du script : bash scripts/louvain_data_treatment.sh  [repertoire de sortie]  [fichier d’output de louvain]  [fichier des données sur les contigs] 

lancement du script : 

> bash scripts/louvain_data_treatment.sh  output/  binning/output_louvain.txt  data_contigs/idx_contig_length_hit_cov_GC_XX.txt

Qi25 : Combien de bins détectez-vous ?

Qi26 : Combien de contigs ne sont associés à aucun autre (ou combien de communautés ne comprennent qu'un seul contig) ?

Qi27 : Combien de bin contiennent plus de 10 Kb, 100 Kb, 500 Kb et 1 Mb de séquences ?

Qi28 : Notez bien ces chiffres et refaites tourner l'algorithme avec les mêmes lignes de commandes (pas grave si vous écrasez les fichiers existants !!) Détectez-vous le même nombre de communautés que précédemment ? Ces communautés sont-elles de la même taille ?

Qi29 : Qu'en déduisez-vous ?


•	Louvain itératif

L'algorithme de Louvain est non déterministe, c'est à dire qu'en utilisant un jeu de données identiques, les résultats produits seront différents à chaque fois. Il est donc possible d'utiliser cette propriété de l'algorithme pour réaliser une sorte de bootstraping de notre partitionnement en communauté. Nous allons donc réaliser plusieurs itérations indépendantes de l'algorithme et de regrouper les contigs qui ségrégent toujours ensemble au cours des différentes itérations.

Etape 1 : génération des données brutes des 100 itérations de Louvain

NB le fichier binaire existe déjà, il est donc inutile de le recréer !!! gain de temps de calcul !!!
nous allons réaliser une boucle afin de réaliser 100 itérations de Louvain

pour cela on va générer une variable avec la fonction seq qui va compter de 1 à 100

> for iteration in $(seq 1 100)

> do

> ~/Bureau/install/louvain/louvain  binning/net.bin  -l  -1  -w binning/net.weights  >  binning/net.tree 

> ~/Bureau/install/louvain/hierarchy  binning/net.tree  >  binning/level_louvain.txt 

> level=$(tail  -1  binning/level_louvain.txt | awk '{print $2}' | sed 's/://')

> ~/Bureau/install/louvain/hierarchy  binning/net.tree  -l  "$level"  >  binning/louvain_"$iteration".txt

> done 

PETITE PAUSE le temps que les 100 itérations se fassent

Etape 2 : génération d’un output de Louvain


> for iteration in $(seq 1 100) 

> do 

> cat  binning/louvain_"$iteration".txt  |  awk  '{print $1}'  >  temp/contig_idx.txt 

> cat  binning/louvain_"$iteration".txt  |  awk  '{print $2";"}'  >  temp/bin_idx_"$iteration".txt

> done 

> paste  temp/bin_idx_*  | sed 's/\t//g'  >  temp/temp1.txt 

> paste  temp/contig_idx.txt  temp/temp1.txt  |  awk  '{print $1,$2}'  > binning/output_louvain_100it.txt



Qi30 : en utilisant les scripts utilisés aujourd’hui refaites la même analyse des bins obtenus après 100 itérations de Louvain (nombre de bins, répartition en fonction de leur taille).


Il est également possible d’analyser l’évolutions des différentes communautés en fonction du nombre d’itérations de Louvain (1, 5, 10, 20, 50, 100). A l’aide de vos connaissances, des scripts déjà utilisés et des données fournies, réaliser une analyse de l'évolution des groupes de contigs en fonction du nombre d'itérations de l'algorithme de Louvain (cf polycopié du TP)

Qi31 : Comment évolue votre binning au cours des différentes itérations ? Combien d’itérations de louvain faudrait-il faire (justifier ce choix) ?


