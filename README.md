# Mothur_oligo_batch
Singular batch analysis by mothur/oligotyping

# Install Oligotyping software in your local directory
```R
module load python-anaconda2/201607
pip install --user oligotyping
```
Add path to your bash_profile (if this was not yet the case):
```R
export PATH=/home/rprops/.local/bin:/:$PATH
```
#  Load modules
```R
module load mothur R ncbi-blast
```

# Copy mothur.batch.taxass in your folder with the fastq files
**Make sure the sample names of your fastq files are correct, no ':', '-' or '/' !**

# Run this piece of code to select for a taxon of interest to perform oligotyping analysis on
**If you want to oligotype everything do not run this.**
```R
sed -i "s/Bacteria/Bacteria;Proteobacteria;Betaproteobacteria;Burkholderiales;betI;betI_A/g" mothur.batch.taxass
```
# Make stability file
```R
paste <(ls *R1*.fastq | awk -F"_" '{print $1}') <(ls *R1*.fastq) <(ls *R2*.fastq) > stability.file
```

# Run batch script
mothur mothur.batch.taxass

# or submit everything as a pbs script
qsub mothur.batch.taxass.pbs
