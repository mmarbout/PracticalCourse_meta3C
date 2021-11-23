Session 4 : Analyse d’un assemblage

Différents logiciels permettent d'analyser les résultats d'assemblage. Nous utiliserons le programme quast qui permet d'obtenir différentes statistiques d'assemblage. Il s’utilise en ligne de commande :

explorer le répertoire de sortie de l'assemblage

> ls  -l  assemblage/sampleX/

créer un répertoire de sortie des rapports d'assemblage

> mkdir  -p  assemblage/rapport_assemblage/sampleX

lancer les statistiques d'assemblage

> /Formation_AdG/quast/quast.py  assemblage/sampleX/final.contigs.fa  -o  assemblage/rapport_assemblage/sampleX/  >  log_files/quast_sampleX.log  2>&1 

Afin d'avoir accès aux statistiques, ouvrir le fichier [report.html] (double clic).

Qi12 : Quelles sont les données fournies par Quast ?

Qi13 : Donnez une définition du N50 ?

Qi14 : Quelle est la valeur théorique du N100 ?


Il est également possible de regrouper l’ensemble des données afin d'effectuer un assemblage global de l’expérience. Cet assemblage a été réalisé sur le cluster de calcul de l'Institut Pasteur car le nombre de reads est assez important et, par conséquent, les temps de calcul également.

A l'origine, il y avait 10 patients dans notre cohorte (sample 1 à 10)

Copier l’assemblage de votre choix dans votre répertoire assemblage/ et refaites l’analyse Quast de cet échantillon.

> scp votrelogin@sftcampus.pasteur.fr:/pasteur/gaia/projets/p01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2021-2022/TP_Meta3C/assembly/assembly_sampleXX.fa assemblage/  

créer un répertoire de sortie 

> mkdir  -p  assemblage/rapport_assemblage/sampleXX

lancer les statistiques d'assemblage

> /Formation_AdG/quast/quast.py  assemblage/assembly_sampleXX.fa  -o  assemblage/rapport_assemblage/sampleXX  >  log_files/quast_XX.log  2>&1

Désormais vous allez travailler sur l’assemblage d'un échantillon de la cohorte.

et rassurez vous ... la pause arrive très bientot !!!
