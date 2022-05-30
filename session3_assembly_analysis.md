# Session 3 : Analyse d’un assemblage

Différents logiciels permettent d'analyser les résultats d'assemblage. Nous utiliserons le programme quast qui permet d'obtenir différentes statistiques sur un assemblage. Il s’utilise en ligne de commande :

explorer le répertoire de sortie de l'assemblage

```sh
ls  -l  assemblage/sampleX/
```

créer un répertoire de sortie des rapports d'assemblage

```sh
mkdir  -p  assemblage/rapport_assemblage/sampleX
```

lancer les statistiques d'assemblage

```sh
/Formation_AdG/quast-5.1.0rc1/quast.py  assemblage/sampleX/final.contigs.fa  -o  assemblage/rapport_assemblage/sampleX/  >  log_files/quast_sampleX.log  2>&1 
```

Afin d'avoir accès aux statistiques, ouvrir le fichier [report.html] (double clic).

Qi12 : Quelles sont les données fournies par Quast ?

Qi13 : Donnez une définition du N50 ?

Qi14 : Quelle est la valeur théorique du N100 ?

Nous avons également généré un assemblage issue d'un grand nombre de reads. Cet assemblage a été réalisé sur le cluster de calcul de l'Institut Pasteur car le nombre de reads est assez important et, par conséquent, les temps de calcul et les besoins en ressources également.

Copier l’assemblage dans votre répertoire assemblage/ et refaites l’analyse Quast de cet échantillon.

```sh
scp votrelogin@sftpcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/assembly/assembly_all.fa assemblage/ 
``` 

créer un répertoire de sortie 
```sh
mkdir assemblage/rapport_assemblage/all_sample
```

lancer les statistiques d'assemblage
```sh
/Formation_AdG/quast-5.1.0rc1/quast.py  assemblage/assembly_all.fa  -o  assemblage/rapport_assemblage/all_sample  >  log_files/quast_XX.log  2>&1
```

Désormais vous allez travailler sur cet assemblage.

et rassurez vous ... la pause arrive très bientot !!!