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
In case you have to rename your files adapt the following code line:
```R
find /scratch/vdenef_fluxm/rprops/process2/UM_ML14 -type f -exec rename '-' '' {} \;
```
This will remove "-" from your sample names. You may have to run rerun this several times if you have multiple "-" in your sample names.

# Run this piece of code to select for a taxon of interest to perform oligotyping analysis on
**If you want to oligotype everything do not run this.**
Replace <code> Bacteria;Proteobacteria;Betaproteobacteria;Burkholderiales;betI;betI_A </code> with your taxon of interest.
```R
sed -i "s/Bacteria/Bacteria;Proteobacteria;Betaproteobacteria;Burkholderiales;betI;betI_A/g" mothur.batch.taxass
```
# Make stability file
Should you get an error during <code>make.contigs</code> then check if the &#95;R1&#95; and &#95;R2&#95; pattern does not occur in the sample name.
```R
paste <(ls *_R1_*.fastq | awk -F"_" '{print $1}') <(ls *_R1_*.fastq) <(ls *_R2_*.fastq) > stability.file
```

# Run batch script
```R
mothur mothur.batch.taxass
```
# or all the above as a pbs script
```R
qsub mothur.batch.taxass.pbs
```
