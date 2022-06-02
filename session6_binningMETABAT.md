# Session 6 : Binning des contigs par couverture et fréquence de tétranucléotides (MetaBAT)

Nous allons effectuer un "binning" de nos contigs en utilisant metabat2. Metabat2 est une méthode de regroupement de contigs qui utilise une combinaison de la composition des tétranucléotides de l'ADN et du regroupement de l'abondance. Il est normalement désigné pour traiter des échantillons multiples mais cela va permettre d'apprendre à s'en servir.

Metabat2 crée un profil par contig composé de l'abondance de son kmer et de son profil d'abondance par échantillon et détermine s'il y a des contigs avec un profil similaire. La longueur minimale de contigs autorisée dans metabat2 est de 2kb, car la signature tétranucléotidique se rapproche trop du bruit avec des contigs plus courts que 2kB.

![metabat](docs/images/metabat.jpeg)

créer un répertoire de sortie pour les fichiers metabat

```sh
mkdir  -p  binning/metabat/
```

