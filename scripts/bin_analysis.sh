#!/usr/bin/env bash
# TP Analyse des Génomes
# Martial Marbouty

############################################# PARAMETERS ######################################

# this script will generate a 2D plot of contig GC VS cov of a targeted bin

#usage --> bash bin_analysis.sh targeted_bin output_folder contig_data_file 

#targeted bin
target=$1

#output_folder
output_folder=$2

#path to the contig output file from MetaTOR
contig_data=$3


####################################################################################

mkdir -p "$output_folder"/
mkdir -p temp/

cat "$contig_data" | awk '$17=="'$target'" {print $2,$3,$6,$4}' > temp/bin_data.temp

var1=$(cat temp/bin_data.temp | awk '{print $1}')
rm temp/bin_data2.temp
for contig in $var1
do
	chunk=$(cat temp/bin_data.temp | awk '$1=="'$contig'" {print int($2/1000)+1}')
	cov=$(cat temp/bin_data.temp | awk '$1=="'$contig'" {print $3}')
	GC=$(cat temp/bin_data.temp | awk '$1=="'$contig'" {print $4}')
	seq 0 "$chunk" | awk '{print "'$cov'","'$GC'"}' >> temp/bin_data2.temp
done



scripts/./analyse_bin_GC_cov.r temp/bin_data2.temp "$output_folder"/"$target"_GC_cov.pdf

rm temp/* 