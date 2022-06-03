#!/usr/bin/env bash
# TP Analyse des Génomes
# Martial Marbouty

export LOUVAIN_PATH=software/gen-louvain/

metator network -n -t 4 -1 fastq/libX_filtre_3C_for.fastq.gz -2 fastq/libX_filtre_3C_rev.fastq.gz -a assemblage/assembly_all.fa -o metator_output

mkdir -p temp/
mkdir -p data/
mkdir -p figures/

for threshold in 50 60 70 80 90 100
do

	for iteration in 1 2 3 4 5 10 20 30 40 50
	do

		rm data/thr"$threshold"_data.csv
		metator partition -F -O "$threshold" -i "$iteration" -t 4 -n binning/metator/network.txt -c binning/metator/contig_data_network.txt -a assemblage/assembly_all.fa -o metator_output
		echo "$iteration" > temp/temp_it.txt
		cat contig_data_partition.txt | awk '$10 >= 100000 {print $8,$10}' | sort -u | wc -l >> temp/temp_it.txt
		paste -s temp/temp_it.txt | awk '{print $1";"$2}' >> data/thr"$threshold"_data.csv
	done
done

