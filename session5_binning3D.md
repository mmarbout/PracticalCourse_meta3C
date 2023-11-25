# Session 5 : Binning des contigs par exploitation des interactions inter-contigs (MetaTOR)

La métagénomique permet aujourd'hui d'étudier les micro-organismes non cultivables et ainsi d'appréhender le fonctionnement biologique de tout type d'écosystème. Néanmoins, le séquençage massif ne permet pas un inventaire exhaustif des micro-organismes et encore moins de relier la structure de la communauté et les fonctions biologiques qu'elle assure. Pour pallier cela, il est nécessaire de reconstruire les génomes complets des populations présentes. Cependant, la faible taille des séquences générées associée à la grande diversité des espèces rend l'assemblage des séquences très compliqué. Plusieurs stratégies ont été développées pour tenter de reconstruire des génomes à partir de données métagénomiques, notamment par l'utilisation du binning (cf introduction). Ces méthodes consistent à établir le profil des fragments de génomes selon leur composition en nucléotides et/ou leur abondance au sein d'un ou plusieurs métagénomes. Deux contigs aux profils similaires appartiendraient ainsi au génome d'un même organisme. La technique de Meta3C utilise, elle, les fréquences de collision entre molécules d'ADN, et donc la proximité spatiale des molécules pour regrouper les contigs au sein de "communautés". 


<p align="center">
  <img src="docs/images/metator_logo.png" width="200">
</p>


## MetaTOR - Metagenomic Tridimensional Organisation-based Reassembly

Principle of MetaTOR pipeline:

![metator_pipeline](docs/images/metator_figure.png)

if you want more described doc of MetaTOR and the different possibilities offered by the pipeline , various tutorials are available at the following links:

* package is available [here](https://github.com/koszullab/metaTOR)
* A tutorial is available [here](docs/example/metator_tutorial.md) to explain how to use metaTOR. 
* [Anvio](https://merenlab.org/software/anvio/) manual curation of the contaminated bins. Available [here](docs/example/manual_curation_of_metator_MAGs.md).
* Visualization and scaffolding of the MAGs with the contactmap modules of MetaTOR. Available [here](docs/example/MAG_visualization_and_scaffolding.md).

le programme MetaTOR offre une solution "end to end" ou "step by step" ... nous allons bien sûr suivre les étapes les unes après les autres ;) 

mais avant il va falloir installer quelques programmes. Pour cela nous allons utilisons Conda qui est un système de gestion de paquets et d'environnement open-source qui fonctionne sous Windows, macOS et Linux. Conda installe, exécute et met à jour rapidement les paquets et leurs dépendances. Conda crée, enregistre, charge et bascule facilement entre les environnements sur votre ordinateur local.

Pour gérer conda nous utiliserons micromamba qui est extremement rapide:

```sh
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```

une fois installé , nous pouvons vérifier que tout se passe bien en faisant un update de micromaba

```sh
micromamba self-update
```
il est alors possible de créer un environnement dédié à notre logiciel MetaTOR à partir d'un fichier YAML qui définit l'environnement.

```sh
micromamba env create --name metator --file software/metator_binning.yaml
```

il faut ensuite activer l'envrionnement

```sh
micromamba activate metator
```

pour désactiver l'environnement, il suffit de taper la commande suivant 

```sh
micromamba deactivate
```

gardez bien en tête qu'il faudra activer l'environnement à chaque fois que 'lon veut utiliser MetaTOR.

## Step-by-step

### Génération du réseau d’interactions inter-contig

La première étape va consister à aligner les paires de lectures des librairies 3C sur l’assemblage global afin d'établir un réseau d'interactions entre les contigs de l’assemblage. Ce réseau nous servira ensuite au regroupement (binning) des contigs. 

vous pouvez voir l'ensemble des options du logiciel avec l'option --help

```sh
metator network --help
```

créez un répertoire de sortie pour le binning

```sh
mkdir -p binning
```
et maintenant, lancez la ligne de commande permettant de générer le réseau d'interactions (5 -10 min).

```sh
metator network -t 4 -1 fastq/libX_filtre_3C_for.fastq.gz -2 fastq/libX_filtre_3C_rev.fastq.gz -a assemblage/assembly_all.fa -o binning/metator/
```

en vous servant du fichier log généré par MetaTOR ainsi que du fichier "network" généré, répondez aux questions suivantes:

Qi27 : Combien de nœuds (ou contigs) contient votre réseau global ?

Qi28 : Combien de paires de reads ont été alignées  ?

Qi29 : Combien de paires de reads ont été alignées sur deux contigs différents ?

Qi30 : déduisez en le 3D ratio (nb de reads liant 2 contigs différent par rapport au nombre total de reads alignés)

NB: il est nécessaire de ne pas prendre en compte les interactions au sein d'un même contig (intra-contig)... c'est pourquoi votre réseau ne contient pas les liens intra-contigs.

vous pouvez également faire des tests sur les différentes normalisations offertes par le programme avec l'option -n


### partitionnement du réseau d'interaction

la deuxième étape va consister à détecter les sous réseaux d'interactions au sein de notre grand réseau. Pour cela nous utilisons l'algorithme de Louvain

•	Algorithme de Louvain

![louvain_algo](docs/images/louvain.png)

La plupart des graphes de terrains (type de graphe mathématiques) exhibent une structure communautaire. Une communauté se définit comme un sous-graphe composé de nœuds densément reliés entre eux et faiblement liés aux autres nœuds du graphe. La méthode Meta3C est basée sur cette notion et le fait que deux séquences d'ADN appartenant à un même compartiment cellulaire auront plus fréquemment des interactions que deux séquences appartenant à deux compartiments différents. Pour la détection des "communautés de contigs" (i.e. des groupes de contigs ou bins) nous utiliserons l'algorithme de Louvain. C'est un algorithme hiérarchique qui itère sur deux étapes : 

i - Il cherche les petites communautés en optimisant la modularité de Newman et Girvan d'une manière locale. 

ii - Il fusionne les nœuds de la même communauté et construit un nouveau réseau dont les nœuds sont les communautés. La partition qui a le maximum de modularité est retenue.

Une modularité est une mesure de la qualité d'une partition des sommets (les noeuds) d'un graphe. Le principe est qu'un bon partitionnement d'un graphe implique un nombre d'arêtes (de liens) intra-communautaires important et un nombre d'arêtes inter-communautaires faible.


```sh
metator partition -h
```

nous devons d'abord indiquer au programme ou se trouve l'algorithme de louvain car il ne fait par parti stricto-senso du programme MetaTOR et il est codé en c++. Il faut également lui donner les permissions d'éxécution.

```sh
chmod +x -R software/gen-louvain/
```

```sh
export LOUVAIN_PATH=software/gen-louvain/
```

nous allons maintenant lancer le partionnement de notre réseau avec la ligne de commande suivante:

```sh
metator partition -i 1 -O 100 -t 4 -n binning/metator/network.txt -c binning/metator/contig_data_network.txt -a assemblage/assembly_all.fa -o binning/metator/
```

explorer le dossier de sortie et notamment le fichier contig_data_partition.txt


```sh
cat binning/metator/contig_data_partition.txt | head
```

Qi31 : Combien de bins détectez-vous ?

Qi32 : Combien de contigs ne sont associés à aucun autre (ou combien de communautés ne comprennent qu'un seul contig) ?

Qi33 : Combien de bin contiennent plus de 10 Kb, 100 Kb, 500 Kb et 1 Mb de séquences ?

Notez bien ces chiffres et refaites tourner l'algorithme avec les mêmes lignes de commandes (il faut mettre l'option -F afin d'écraser les fichiers existants !! ou sinon vous mettez les fichiers de sorties dans un repertoire différent ;)) 

```sh
metator partition -i 1 -O 100 -F -t 4 -n binning/metator/network.txt -c binning/metator/contig_data_network.txt -a assemblage/assembly_all.fa -o binning/metator/
```

Qi34 : Détectez-vous le même nombre de communautés que précédemment ? Ces communautés sont-elles de la même taille ? Qu'en déduisez-vous ?


•	Louvain itératif

L'algorithme de Louvain est non déterministe, c'est à dire qu'en utilisant un jeu de données identiques, les résultats produits seront différents à chaque fois. Il est donc possible d'utiliser cette propriété de l'algorithme pour réaliser une sorte de "bootstraping" de notre partitionnement en communauté. Nous allons donc réaliser plusieurs itérations indépendantes de l'algorithme et de regrouper les contigs qui ségrégent toujours ensemble au cours des différentes itérations. Il est également possible de faire varier le seuil a partir duquel 2 contigs seront regroupés ensemble (overlapping communities).

ces différents paramètres se contrôle avec les options

    -O overlapping threshold (%) ex: -O 80
    -i nombre d'itérations ex: -i 40

Il est ainsi possible d’analyser l’évolutions des différents groupes de contigs en fonction du nombre d’itérations de Louvain (1, 5, 10, 20, 30, 40, 50) et du seuil de regroupement des contigs (70%, 80%, 90%, 100%). 

A l’aide de vos connaissances, des scripts déjà utilisés et des données fournies, choisisissez le seuil qui vous semble le plus approprié et réaliser une analyse de l'évolution des groupes de contigs en fonction du nombre d'itérations de l'algorithme de Louvain (cf graph ci-dessous)

Qi34 : Comment évolue votre binning au cours des différentes itérations ? Combien d’itérations de louvain faudrait-il faire selon vous (justifier ce choix) ?

à vous de jouer ;)

![louvain_iteration1](docs/images/louvain_ite.png)






