#!/bin/sh
#SBATCH --qos=normal
#SBATCH --mem=24G
#SBATCH -n 16
#SBATCH -N 1
#SBATCH -o binning_analysis.out.txt -e binning_analysis.err.txt

############################################# USAGE ######################################

# this script will generate different plot based on MetaTOR output

#usage --> bash binning_analysis.sh folder_MetatOR output_folder  

############################################# INPUT/OUTPUT ######################################

#files containning the different output from MetaTOR pipeline
contig_data=$1
bin_data=$2

#output_folder
out_fold=$3

####################################################################################

mkdir -p "$out_fold"/
mkdir -p "$out_fold"/temp/

assembly=$(cat "$contig_data" | sed '1d' | awk '{sum+=$3} END {print sum}')

cat "$bin_data" | LC_NUMERIC="C" awk '$3>=90 && $4<=5 {print $5}' | wc -l > "$out_fold"/temp/MAGs_number.txt
cat "$bin_data"  | LC_NUMERIC="C" awk '$3>=90 && $4<=10 && $4>5 {print $5}' | wc -l >> "$out_fold"/temp/MAGs_number.txt
cat "$bin_data"  | LC_NUMERIC="C" awk '$3>=80 && $3<90 && $4<=10 {print $5}' | wc -l >> "$out_fold"/temp/MAGs_number.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=70 && $3<80 && $4<=10 {print $5}' | wc -l >> "$out_fold"/temp/MAGs_number.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=60 && $3<70 && $4<=10 {print $5}' | wc -l >> "$out_fold"/temp/MAGs_number.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=50 && $3<60 && $4<=10 {print $5}' | wc -l >> "$out_fold"/temp/MAGs_number.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3<50 && $4<=10 {print $5}' | wc -l >> "$out_fold"/temp/MAGs_number.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$4>10 {print $5}' | wc -l >> "$out_fold"/temp/MAGs_number.txt

cat "$run_fold"/contig_data_final.txt | sed '1d' | grep -v "MetaTOR" | awk '{print $13}' | sort -u | wc -l >> "$out_fold"/temp/MAGs_number.txt

cat "$bin_data" | LC_NUMERIC="C" awk '$3>=90 && $4<=5 {print $5}' | awk '{sum+=$1} END {print sum}'> "$out_fold"/temp/MAGs_size.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=90 && $4<=10 && $4>5 {print $5}' | awk '{sum+=$1} END {print sum}' >> "$out_fold"/temp/MAGs_size.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=80 && $3<90 && $4<=10 {print $5}' | awk '{sum+=$1} END {print sum}' >> "$out_fold"/temp/MAGs_size.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=70 && $3<80 && $4<=10 {print $5}' | awk '{sum+=$1} END {print sum}' >> "$out_fold"/temp/MAGs_size.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=60 && $3<70 && $4<=10 {print $5}' | awk '{sum+=$1} END {print sum}' >> "$out_fold"/temp/MAGs_size.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3>=50 && $3<60 && $4<=10 {print $5}' | awk '{sum+=$1} END {print sum}' >> "$out_fold"/temp/MAGs_size.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$3<50 && $4<=10 {print $5}' | awk '{sum+=$1} END {print sum}' >> "$out_fold"/temp/MAGs_size.txt
cat "$bin_data" | LC_NUMERIC="C" awk '$4>10 {print $5}' | awk '{sum+=$1} END {print sum}' >> "$out_fold"/temp/MAGs_size.txt

cat "$bin_data" | LC_NUMERIC="C" awk '{print $5}' | awk '{sum+=$1} END {print sum}' | awk '{print "'$assembly'"-$1}' >> "$out_fold"/temp/MAGs_size.txt

cat "$bin_data" | sed '1d' | awk '{print $1,$2,$3,$4,$5}' | LC_NUMERIC="C" sort -k 3,3 -g -r -k 4,4 -g > "$out_fold"/temp/MAGs_summary.txt
cat cat "$contig_data" | sed '1d' | grep "MetaTOR" | awk '{print $2,$3,$6,$4,$17,$16}' > "$out_fold"/temp/contig_data.txt

scripts/./data_binning.r "$out_fold"/temp/MAGs_size.txt "$out_fold"/temp/MAGs_summary.txt "$out_fold"/temp/contig_data.txt "$out_fold"/pie_MAGs_repartition.pdf "$out_fold"/barplot_MAGs_compl_conta.pdf "$out_fold"/boxplot_cov_MAGs.pdf "$out_fold"/boxplot_GC_MAGs.pdf

