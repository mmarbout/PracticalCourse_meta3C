# Session 6 : Analyse et validation des bins obtenus

Différentes approches permettent de valider les bins obtenus. Nous allons essayer de passer en revue différentes méthodes permettant de valider notre binning.

Mais avant de pouvoir commencer cette session ... il va falloir installer quelques programmes et librairies !!

1- une librairie python permettant de télécharger d'autres librairies python 

```sh
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py
```

ensuite lancez la commande suivante:
```sh
python get-pip.py
```

2- des librairies python via la commande pip

```sh
~/.local/bin/pip3 install matplotlib Tk hicstuff
```

3- un package nécessaire via la commande apt-get

```sh
sudo apt-get install python3-tk
```

4- le programme micomplete

```sh
pip install micomplete
```

maintenant ... on peut commencer !!

##	Marqueurs taxonomiques

![checkM](docs/images/checkm.png)

Différents programmes existent afin de valider les bins obtenus après partitionnement d'un métagénome (CheckM, Micomplete). Dans notre cas nous utiliserons Micomplete qui est moins complet mais beacoup moins gourmand que CheckM.

La validation des bins avec ce programme consiste à rechercher un set de gènes bactériens (via des modèles HMM), essentiels et présents en une seule copie dans plus de 97% des génomes bactériens connus.

L’absence/présence et la multiplicité de ces marqueurs permettent ainsi d’évaluer : 

i - la complétude (mesure reliée au nombre de marqueurs au sein d'un bin par rapport au nombre attendu.

ii - la contamination (mesure reliée au nombre de marqueurs en plusieurs copies).

![micomplete](docs/images/micomplete.png)


pour lancer micomplete, il faut d'abord changer les extensions des bins (.fa --> .fna)

```sh
var=$(ls -l binning/metator/bins/overlapping_bin/ | sed '1d' | awk '{print $9}' | awk -F "." '{print $1}')
for i in $var; do mv binning/metator/overlapping_bin/"$i".fa binning/metator/overlapping_bin/"$i".fna; done
```

il faut ensuite construire un fichier nécessaire au fonctionnement de micomplete

```sh
find binning/metator/overlapping_bin/ -maxdepth 1 -type f -name "*.fna" | micomplete/micomplete/utils/miCompletelist.sh > binning/metator/overlapping_bin/listbins.tab
```

on peut ensuite lancer l'analyse:

```sh
micomplete/micomplete/micomplete.py binning/metator/overlapping_bin/listbins.tab --threads 8 --hmms Bact105 -o binning/metator/miComplete.txt 
```

et jeter un oeil aux résultats

```sh
cat binning/metator/miComplete.txt | head
```

Nous considèrerons un génome complet quand :

o	sa complétude se situe au-delà de 90% (>0.9)

o	sa contamination se situe en deçà de 10% (<1.1)

Qi35 : Combien de génome(s) reconstruit(s) et complet(s) avez-vous ? Quelle proportion en terme de séquence cela représente t il ?

![outMAG](docs/images/outMAG6.png)

![outMAG](docs/images/outMAG1.png)

![outMAG](docs/images/outMAG8.png)

##	Couverture et contenu en GC

Une autre façon de vérifier la qualité de nos bins est de regarder l’homogénéité de leur couverture et de leur contenu en GC.

à l'aide des données du fichier contig_data_partition.txt, générez les graph ci-dessous (boxplot)

![outMAG](docs/images/outMAG3.png)

![outMAG](docs/images/outMAG4.png)


Il est également possible de générer des « density plot » pour chaque bin afin de vérifier leur homogénéité ou au contraire voir si il y a différentes populations de contigs.

![outMAG](docs/images/outMAG7.png)

pour celui là , je vais vous filer un coup de pouce ... 

lancement du script bin_analysis.sh qui prends 3 arguments en entrée [1-targeted_bin; 2-output_directory; 3-contig_data_file from MetaTOR]

ATTENTION ICI !!!!  ne recopiez pas la ligne de commande betement !! il faut remplacer targeted bin par un bin que vous souhaitez étudier et le fichier contig_data par celui correspondant aux process en question ...

> bash scripts/bin_analysis.sh  targeted_bin  figure/  output_MetaTOR/contig_data_final.txt 

##	Matrices d’interactions

A partir de n'importe quel réseau ou fichier d’alignement, il est possible de générer une matrice qui est une méthode de visualisation de graphe.

Pour cela, nous allons utiliser le script bins_matrix_generation.sh écrit en bash et qui permet de recouper les différentes informations et de générer une matrice non réordonnée et une matrice réordonnée des contigs de l’assemblage :

usage du script : bash bins_matrix_generation.sh  [fichier de sortie des données de louvain]  [fichier de l’alignement]  [dossier d’output]  [taille des pixels x 5Kb]

idem que au dessus concernant la ligne de commande !!!

vous êtes désormais (enfin j'espère) suffisamment à l'aise avec ces lignes de commandes et les arguments pour vous en sortir tout seul ;)

cela prend un peu de temps !! c'est une assez grosse matrice

attention

lancement du script :

> bash scripts/bins_matrix_generation.sh  output_MetaTOR/XX_contig_data_jesaispasquoi.txt  network/alignment_sampleXX.txt  figure/  20

