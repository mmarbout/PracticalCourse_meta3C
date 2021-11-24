Session 6 : Binning des contigs par exploitation des interactions inter-contigs

La métagénomique permet aujourd'hui d'étudier les micro-organismes non cultivables et ainsi d'appréhender le fonctionnement biologique de tout type d'écosystème. Néanmoins, le séquençage massif ne permet pas un inventaire exhaustif des micro-organismes et encore moins de relier la structure de la communauté et les fonctions biologiques qu'elle assure. Pour pallier cela, il est nécessaire de reconstruire les génomes complets des populations présentes. Cependant, la faible taille des séquences générées associée à la grande diversité des espèces rend l'assemblage des séquences très compliqué. Plusieurs stratégies ont été développées pour tenter de reconstruire des génomes à partir de données métagénomiques, notamment par l'utilisation du binning (cf introduction). Ces méthodes consistent à établir le profil des fragments de génomes selon leur composition en nucléotides et/ou leur abondance au sein d'un ou plusieurs métagénomes. Deux contigs aux profils similaires appartiendraient ainsi au génome d'un même organisme. La technique de Meta3C utilise, elle, les fréquences de collision entre molécules d'ADN, et donc la proximité spatiale des molécules pour regrouper les contigs au sein de "communautés". 

•	Génération du réseau d’interactions inter-contig

La première étape va consister à aligner les paires de lectures sur l’assemblage global afin d'établir un réseau d'interactions entre les contigs de l’assemblage. Ce réseau nous servira ensuite au regroupement (binning) des contigs. Le programme MetaTOR a déjà été lancé avec l’ensemble des données fastq afin de générer un réseau d’interaction global contenant l’ensemble des expériences pour nos différents échantillons.

Les données générées par notre programme se trouve sur GAIA. Copier les fichiers correspondants à votre échantillon dans votre dossier [network/].

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/Network/sampleXX_* network/

vous aurez aussi besoin d'un fichier contenant les données des contigs

> mkdir -p data_contigs/

> scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/data_contigs/contig_data_sampleXX.txt data_contigs/

explorer le répertoire network

> ls  -l  network/

fichier=XX_network.txt (col1: contig1 (nœud1) / col2: contig2 (noeud2) / col3: score)

fichier=XX_network_raw.txt (col1: contig1 (nœud1) / col2: contig2 (noeud2) / col3: score)

fichier=XX_network_norm.txt (col1: contig1 (nœud1) / col2: contig2 (noeud2) / col3: score normalisé)


Qi24 : Quelles sont les différences entre les différents fichiers Network ?

Qi25 : Combien de nœuds contient votre réseau global ?

Qi26 : Combien de liens différents contient-il (c-a-d entre 2 contigs, sans tenir compte du poids de ces liens) ?

Qi27 : Combien de liens au total contient-il ?


•	Algorithme de Louvain

La plupart des graphes de terrains (type de graphe mathématiques) exhibent une structure communautaire. Une communauté se définit comme un sous-graphe composé de nœuds densément reliés entre eux et faiblement liés aux autres nœuds du graphe. La méthode Meta3C est basée sur cette notion et le fait que deux séquences d'ADN appartenant à un même compartiment cellulaire auront plus fréquemment des interactions que deux séquences appartenant à deux compartiments différents. Pour la détection des "communautés de contigs" (i.e. des groupes de contigs ou bins) nous utiliserons l'algorithme de Louvain. C'est un algorithme hiérarchique qui itère sur deux étapes : 

i - Il cherche les petites communautés en optimisant la modularité de Newman et Girvan d'une manière locale. 

ii - Il fusionne les nœuds de la même communauté et construit un nouveau réseau dont les nœuds sont les communautés. La partition qui a le maximum de modularité est retenue.

Une modularité est une mesure de la qualité d'une partition des sommets (les noeuds) d'un graphe. Le principe est qu'un bon partitionnement d'un graphe implique un nombre d'arêtes (de liens) intra-communautaires important et un nombre d'arêtes intercommunautaires faible.

•	Détection de communautés par l'algorithme de Louvain

création d’un répertoire de sortie

> mkdir  -p  binning/

conversion d'un fichier texte en fichier binaire utilisable par l’algorithme de Louvain

> /Formation_AdG/gen-louvain/convert  -i  network/XX_network_norm.txt  -o  binning/net.bin  -w  binning/net.weights

calcul des communautés et rendu d'un arbre hiérarchique

> /Formation_AdG/gen-louvain/louvain binning/net.bin  -l  -1  -w binning/net.weights  >  binning/net.tree

calcul des informations concernant l'arbre hiérarchique (nb de niveau et nb de communautés par niveau)

> /Formation_AdG/gen-louvain/hierarchy  binning/net.tree  >  binning/level_louvain.txt

rendu de l'appartenance d'un nœud à une communauté pour un niveau hiérarchique donné
NB : nous travaillons toujours avec le dernier niveau. C'est à vous de le déterminer en fonction du fichier "level_louvain.txt"

donc NE ME METTEZ PAS UNE LIGNE DE COMMANDE AVEC UN "?" !!!!!!!

explorez le fichier level.txt

> cat binning/level_louvain.txt

quel level devez vous prendre ? il s'agit de son indice qu'il faut mettre !!! 

> /Formation_AdG/gen-louvain/hierarchy  binning/net.tree  -l  ?  >  binning/output_louvain.txt

Le fichier obtenu comprend dans la colonne 1 l'indice du contig et dans la colonne 2 l'indice de la communauté. 
A partir de ce fichier et du fichier contenant les données des contigs (taille, couverture, contenu en GC), on peut générer tout un ensemble de données sur les communautés ou « bins » déterminés par l’algorithme de louvain. Pour cela, nous allons utiliser le script louvain_data_treatment écrit en bash et qui permet de recouper les différentes informations et de générer divers fichiers :

-	contig_data.txt : contig – length – coverage – GC content – bin id – bin size 
-	bin_data: bin – bin size

usage du script : bash scripts/louvain_data_treatment.sh  [repertoire de sortie]  [fichier d’output de louvain]  [fichier des données sur les contigs] 

lancement du script : 

> bash scripts/louvain_data_treatment.sh  output_binning/  binning/output_louvain.txt  data_contigs/contig_data_sampleXX.txt

Les infos importantes sont dans le dossier output_binning/

et dans les fichiers :

-	contig_data.txt : contig – length – coverage – GC content – bin id – bin size

-	bin_data: bin – bin size

Qi28 : Combien de bins détectez-vous ?

Qi29 : Combien de contigs ne sont associés à aucun autre (ou combien de communautés ne comprennent qu'un seul contig) ?

Qi30 : Combien de bin contiennent plus de 10 Kb, 100 Kb, 500 Kb et 1 Mb de séquences ?

Qi31 : Notez bien ces chiffres et refaites tourner l'algorithme avec les mêmes lignes de commandes (pas grave si vous écrasez les fichiers existants !!) Détectez-vous le même nombre de communautés que précédemment ? Ces communautés sont-elles de la même taille ?

Qi32 : Qu'en déduisez-vous ?


•	Louvain itératif

L'algorithme de Louvain est non déterministe, c'est à dire qu'en utilisant un jeu de données identiques, les résultats produits seront différents à chaque fois. Il est donc possible d'utiliser cette propriété de l'algorithme pour réaliser une sorte de bootstraping de notre partitionnement en communauté. Nous allons donc réaliser plusieurs itérations indépendantes de l'algorithme et de regrouper les contigs qui ségrégent toujours ensemble au cours des différentes itérations.

Etape 1 : génération des données brutes des 100 itérations de Louvain

NB le fichier binaire existe déjà, il est donc inutile de le recréer !!! gain de temps de calcul !!!
nous allons réaliser une boucle afin de réaliser 100 itérations de Louvain

pour cela on va générer une variable avec la fonction seq qui va compter de 1 à 100

> for iteration in $(seq 1 100)

> do

> /Formation_AdG/gen-louvain/louvain  binning/net.bin  -l  -1  -w binning/net.weights  >  binning/net.tree 

> /Formation_AdG/gen-louvain/hierarchy  binning/net.tree  >  binning/level_louvain.txt 

> level=$(tail  -1  binning/level_louvain.txt | awk '{print $2}' | sed 's/://')

> /Formation_AdG/gen-louvain/hierarchy  binning/net.tree  -l  "$level"  >  binning/louvain_"$iteration".txt

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

à partir de ce fichier output_louvain_100it.txt ... vous pouvez refaire tourner le script louvain_data_treatment en y mettant les bons arguments et ainsi obtenir 2 fichiers de sortie !!

faites la commande vous meme en vous inspirant de celle deja faites précédemment


Qi33 : en utilisant les scripts utilisés aujourd’hui refaites la même analyse des bins obtenus après 100 itérations de Louvain (nombre de bins, répartition en fonction de leur taille).
combien de bin entre 2 et 10Kb ? entre 10 et 100Kb ? entre 100 et 500Kb ? au dela de 500 Kb ?


Il est également possible d’analyser l’évolutions des différentes communautés en fonction du nombre d’itérations de Louvain (1, 5, 10, 20, 50, 100). A l’aide de vos connaissances, des scripts déjà utilisés et des données fournies, réaliser une analyse de l'évolution des groupes de contigs en fonction du nombre d'itérations de l'algorithme de Louvain (cf polycopié du TP)

pour cela, vous avez déjà les fichiers binning/louvain_"$iteration".txt ... vous pouvez donc refaire la 2ème boucle pour obtenir les résultats à chaque itérations

je vous détaille un peu les lignes de commande mais vous ne devez pas les utiliser aveuglèment ;)

inspirez vous en !!!

NB: il faut supprimer les fichiers d'avant !!!!

> rm temp/*

> for iteration in $(seq 1 iteration souhaité)

> do

> cat  binning/louvain_"$iteration".txt  |  awk  '{print $1}'  >  temp/contig_idx.txt 

> cat  binning/louvain_"$iteration".txt  |  awk  '{print $2";"}'  >  temp/bin_idx_"$iteration".txt

> done 

> paste  temp/bin_idx_*  | sed 's/\t//g'  >  temp/temp1.txt 

> paste  temp/contig_idx.txt  temp/temp1.txt  |  awk  '{print $1,$2}'  > binning/output_louvain_"iterations souhaité".txt


NB: les fichiers output_louvain_XX.txt ne sont pas exploitables en l'état ... pensez bien à refaire tourner le script louvain_data_treatment.sh à chaque fois
et faites attention !!! les fichiers de sorties risquent d'écraser vos fichiers précedents !!!

une autre possibilité serait de changer le repertoire de sortie ;)

Qi34 : Comment évolue votre binning au cours des différentes itérations ? Combien d’itérations de louvain faudrait-il faire (justifier ce choix) ?


