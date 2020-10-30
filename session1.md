Vous allez travailler avec 4 fichiers de sorties de séquençage : les reads en sens (forward) et en anti-sens (reverse) pour chaque banque construites (ShotGun et 3C). Vos fichiers sont nommés ainsi et se trouve sur l'espace GAIA:

sampleX_SG_for.fastq.gz

sampleX_SG_rev.fastq.gz

sampleX_3C_for.fastq.gz

sampleX_3C_rev.fastq.gz

Avant de procéder à l'analyse ou à l'exploitation d'un ensemble de données de séquençage, il est impératif de réaliser des contrôles de qualité des séquences brutes et d'appliquer des filtres si nécessaires. Cette opération permettra de s'assurer qu'il n'y a pas de problèmes cachés dans vos données initiales et de travailler avec des séquences de bonne qualité.

se placer sur le bureau de la Machine virtuelle

> cd 

créer un répertoire 

> mkdir TP_Meta3C 

toutes les lignes de commande que vous verrez s'exécuteront depuis cet emplacement

> cd  TP_Meta3C/

créer un répertoire pour y déposer les fichiers fastq

> mkdir fastq/

copier les fichiers fastq (copier celui correspondant à votre "echantillon")

> scp 

visualiser vos données fastq 

> zcat  fastq/sampleX_SG_for.fastq.gz  |  head

> zcat  fastq/sampleX_SG_rev.fastq.gz  |  head

> zcat  fastq/sampleX_SG_for.fastq.gz  |  head

> zcat  fastq/sampleX_3C_rev.fastq.gz  |  head



