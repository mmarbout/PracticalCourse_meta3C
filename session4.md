4 – Analyse d’un assemblage

Différents logiciels permettent d'analyser les résultats d'assemblage. Nous utiliserons le programme quast qui permet d'obtenir différentes statistiques d'assemblage. Il s’utilise en ligne de commande :

explorer le répertoire de sortie de l'assemblage

> ls  -l  assemblage/sampleX/

créer un répertoire de sortie des rapports d'assemblage

> mkdir  -p  assemblage/rapport_assemblage/sampleX

lancer les statistiques d'assemblage

> software/quast/quast.py  assemblage/sampleX/final.contigs.fa  -o  assemblage/rapport_assemblage/  >  log_files/quast_sampleX.log  2>&1 

Afin d'avoir accès aux statistiques, ouvrir le fichier [report.html] (double clic).

Il est également possible de regrouper l’ensemble des données afin d'effectuer un assemblage global de l’expérience. Cet assemblage a été réalisé sur le cluster de calcul de l'Institut Pasteur car le nombre de reads est assez important et, par conséquent, les temps de calcul également. 
Copier l’assemblage global correspondant à votre échantillon (9010 ou 10015) dans votre répertoire /assemblage et refaites l’analyse Quast de votre échantillon.

lancer les statistiques d'assemblage

> software/quast/quast.py  assemblage/assemblage_XX_500.fa  -o  assemblage/rapport_assemblage/  >  log_files/quast_XX.log  2>&1


Désormais vous allez travailler sur l’assemblage global correspondant à votre échantillon (9010 ou 10015).
