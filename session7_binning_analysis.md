# session 7 : Analyse des bins obtenus

pour cette session, il va falloir récupérer les données

##	Couverture et contenu en GC

Une autre façon de vérifier la qualité de nos bins est de regarder l’homogénéité de leur couverture et de leur contenu en GC.

à l'aide des données du fichier contig_data_partition.txt, générez les graph ci-dessous (boxplot)

![outMAG](docs/images/outMAG3.png)

![outMAG](docs/images/outMAG4.png)

si vous avez un peu de mal ... vous pouvez jeter un oeil au script binning_analysis.sh dans le dossier scripts/.


##	analyse de bin unique

Il est également possible de générer des « density plot » pour chaque bin afin de vérifier leur homogénéité ou au contraire voir si il y a différentes populations de contigs.

![outMAG](docs/images/outMAG7.png)

pour celui là , je vais vous filer un coup de pouce ... il y aun dossier scripts/

lancement du script bin_analysis.sh qui prends 3 arguments en entrée [1-targeted_bin; 2-output_directory; 3-contig_data_file from MetaTOR]

```sh
bash scripts/bin_analysis MetaTOR_2_0 figures/ binning/metator_all/contig_data_final.txt
```

##	Matrices d’interactions

A partir de n'importe quel réseau ou fichier d’alignement, il est possible de générer une matrice qui est une méthode de visualisation de graphe.

Pour cela, nous allons utiliser une fonction de notre programme MetaTOR qui permet de générer des matrices d'interactions pour différents "objets" (contig, core_bin, overlapping, bin, final_bin)

```sh
metator contactmap -h
```
on peut par exemple, 

