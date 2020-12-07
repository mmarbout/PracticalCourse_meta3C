Session 4 : Analyse d’un assemblage

Différents logiciels permettent d'analyser les résultats d'assemblage. Nous utiliserons le programme quast qui permet d'obtenir différentes statistiques d'assemblage. Il s’utilise en ligne de commande :

explorer le répertoire de sortie de l'assemblage

> ls  -l  assemblage/sampleX/

créer un répertoire de sortie des rapports d'assemblage

> mkdir  -p  assemblage/rapport_assemblage/sampleX

lancer les statistiques d'assemblage

> ~/Bureau/install/quast-5.0.1/quast.py  assemblage/sampleX/final.contigs.fa  -o  assemblage/rapport_assemblage/sampleX/  >  log_files/quast_sampleX.log  2>&1 

Afin d'avoir accès aux statistiques, ouvrir le fichier [report.html] (double clic).

Qi12 : Quelles sont les données fournies par Quast ?

Qi13 : Donnez une définition du N50 ?

Qi14 : Quelle est la valeur théorique du N100 ?


Il est également possible de regrouper l’ensemble des données afin d'effectuer un assemblage global de l’expérience. Cet assemblage a été réalisé sur le cluster de calcul de l'Institut Pasteur car le nombre de reads est assez important et, par conséquent, les temps de calcul également. 

Copier l’assemblage global correspondant à votre échantillon (9010 ou 10015) dans votre répertoire assemblage/ et refaites l’analyse Quast de votre échantillon.

> scp votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/assemblage/assemblage_XX_500.fa assemblage/  

lancer les statistiques d'assemblage

> ~/Bureau/install/quast-5.0.1/quast.py  assemblage/assemblage_XX_500.fa  -o  assemblage/rapport_assemblage/  >  log_files/quast_XX.log  2>&1

Désormais vous allez travailler sur l’assemblage global correspondant à votre échantillon (9010 ou 10015).
