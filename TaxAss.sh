#!/bin/bash
# USAGE: bash -x TaxAss.sh
# This is a shell script for applying the TaxAss pipeline by: https://github.com/McMahonLab/TaxAss


## Set variables
# Provide name of fasta file of samples to classify
fasta=$1 
echo $1
# Number of Processors
processors=20

#####################################################################################################
### Do not adjust anything below this line unless you want to update the databases
### If there are issues with the classification (e.g. fully unclassified OTUs) 
### please delete all files in the database folder other than .fasta/.align and .tax/.taxonomy. 
### Then rerun the analysis.
#####################################################################################################

## Specific database (FWDB)
fasta_ref="/nfs/vdenef-lab/Shared/Ruben/databases_taxass/FreshTrain18Aug2016.fasta"
taxonomy_ref="/nfs/vdenef-lab/Shared/Ruben/databases_taxass/FreshTrain18Aug2016.taxonomy"
## General database (SILVA)
general_fasta="/nfs/vdenef-lab/Shared/Ruben/databases_taxass/silva.nr_v123.align"
general_tax="/nfs/vdenef-lab/Shared/Ruben/databases_taxass/silva.nr_v123.tax"
pid=97
script_location="/nfs/vdenef-lab/Shared/Ruben/scripts_taxass"

#####################################################################################################
### Run classification code
#####################################################################################################

# Remove '-' due to alignment (BLAST can't cope with this)
sed -e '/>/!s/-//g' <$(echo $fasta) >sequence.fasta

# Step 0: Create blast database
makeblastdb -dbtype nucl -in $(echo $fasta_ref) -input_type fasta -parse_seqids -out FWonly_18Aug2016custom.db

# Step 1: Run blast and reformat output blast file
blastn -query sequence.fasta -task megablast -db FWonly_18Aug2016custom.db -out custom.blast -outfmt 11 -max_target_seqs 5 -num_threads $processors
blast_formatter -archive custom.blast -outfmt "6 qseqid pident length qlen qstart qend" -out otus.custom.blast.table

# Step 2: Correct BLAST pident using custom script / This accounts for sequence length differences
Rscript $(echo "$script_location/calc_full_length_pident.R") otus.custom.blast.table otus.custom.blast.table.modified

# Step 3: Filter BLAST results
Rscript $(echo "$script_location/filter_seqIDs_by_pident.R") otus.custom.blast.table.modified ids.above.97 $pid TRUE
Rscript $(echo "$script_location/filter_seqIDs_by_pident.R") otus.custom.blast.table.modified ids.below.97 $pid FALSE

# Step 4: 
mkdir plots
Rscript $(echo "$script_location/plot_blast_hit_stats.R") otus.custom.blast.table.modified $pid plots

# Step 5: recover sequence IDs left out of blast (python, bash)
python $(echo "$script_location/find_seqIDs_blast_removed.py") sequence.fasta otus.custom.blast.table.modified ids.missing
cat ids.below.97 ids.missing > ids.below.97.all

# Step 6: create fasta files of desired sequence IDs (python)
python $(echo "$script_location/create_fastas_given_seqIDs.py") ids.above.97 sequence.fasta otus.above.97.fasta
python $(echo "$script_location/create_fastas_given_seqIDs.py") ids.below.97.all sequence.fasta otus.below.97.fasta
