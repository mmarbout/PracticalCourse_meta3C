Session 2 : Annotation taxonomique des reads issues d’un métagénome

Estimer la diversité taxonomique d’un jeu de données métagénomique consiste à déterminer la liste des taxons présents et à calculer leur abondance. L’approche classique consiste à aligner toutes les séquences contre toutes celles d’une ou plusieurs banques de références. Le score d’alignement le plus élevé entre une séquence et une référence est alors utilisé pour estimer leur ressemblance d’un point de vue phylogénétique. Il existe de nombreuses banques de références, telles que RefSeq pour aligner les séquences contre des génomes complets, ou Greengenes pour les aligner contre des marqueurs phylogénétiques connus. Ces dernières présentes l’avantage d’estimer la diversité en n’utilisant qu’une fraction des reads et donc de réduire la taille des bases de données nécessaires ainsi que les temps de calcul. L’inconvénient de ces approches basées sur des références est qu’elles sont limitées par nos connaissances. 
Dans notre cas, nous allons comparer les données à une base de données de marqueurs taxonomiques via les programmes bowtie2 (alignements des reads) et MetaPhlan (analyse des alignements).

bowtie2 est un aligneur de lecture rapide et efficace en mémoire. Il aligne de courtes séquences d'ADN sur le génome humain à un rythme de plus de 25 millions de lectures de 35 pb par heure. bowtie2 indexe le génome avec un index de Burrows-Wheeler afin de conserver une empreinte mémoire réduite (environ 2,2 Go pour le génome humain). Il possède un grand nombre d’option que vous pouvez voir en utilisant la commande : bowtie2 -help

créer un répertoire de sortie des fichiers d’alignement

> mkdir  -p  alignement/

nous allons avoir également besoin du programme metaphlan2 (la versin sur votre VM ne fonctionne pas avec mes base de données)

créer un répertoire contenant les programmes

> mkdir -p software

copier le programme

> scp -r votrelogin@tars.pasteur.fr:/pasteur/projets/policy01/Enseignements/GAIA_ENSEIGNEMENTS/ANALYSE_DES_GENOMES_2020_2021/TP_Meta3C/software/metaphlan2/ software/

donner les autorisations !!

> chmod +X -R software/metaphlan2/

alignement des reads par Bowtie2 contre la base de données MetaPhlan

> bowtie2  --sam-no-hd  --sam-no-sq  --very-sensitive-local  --no-unal  -p 4  -x software/metaphlan2/db_bowtie/mpa_v20_m200 -U fastq/sampleX_filtre_SG_for.fastq.gz  -S alignement/sampleX_filtre_SG_for.sam  >  log_files/bowtie_SG.log  2>&1

> bowtie2  --sam-no-hd  --sam-no-sq  --very-sensitive-local  --no-unal  -p 4  -x software/metaphlan2/db_bowtie/mpa_v20_m200  -U fastq/sampleX_filtre_3C_for.fastq.gz  -S alignement/sampleX_filtre_3C_for.sam  >  log_files/bowtie_3C.log  2>&1

Qi9 : Quel est le taux de mapping de vos reads sur la base de données Metaphlan ? cela vous parait il normal ?

MetaPhlan est un outil informatique écrit en python permettant de définir la composition des communautés microbiennes à partir de données de séquençage métagénomique. MetaPhlAn s'appuie sur des gènes marqueurs uniques et spécifiques, identifiés à partir de 3 000 génomes de référence.

traitement des données par MetaPhlan

> python  software/metaphlan2/metaphlan2.py  alignement/sampleX_filtre_SG_for.sam  --input_type sam  --mpa_pkl  software/metaphlan2/db_bowtie/mpa_v20_m200.pkl  >  log_files/MetaPhlan_SG.log  2>&1

> python software/metaphlan2/metaphlan2.py  alignement/sampleX_filtre_3C_for.sam  --input_type sam  --mpa_pkl  software/metaphlan2/db_bowtie/mpa_v20_m200.pkl  >  log_files/MetaPhlan_3C.log  2>&1

Qi10 : Quelle est la distribution taxonomique de vos jeux de données au niveau du phylum ? de l’ordre ? de la classe ? [Réaliser un graphique pour illustrer votre résultats – camembert ou histogramme avec R par exemple] 

ATTENTION !! ne prenez pas en compte les abondances < 1%

Qi11 : Observez-vous une différence entre vos différentes librairies (SG VS 3C) ?

 

  


