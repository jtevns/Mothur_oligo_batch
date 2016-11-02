# Mothur_oligo_batch
Singular batch analysis by mothur/oligotyping

# Install Oligotyping software in your local directory
```
module load python-anaconda2/201607
pip install --user oligotyping
```
To check to make sure that the path to the oligotyping package is correct, try using a command from the oligotyping module:

```
oligotype -h
```
If it says "-bash: oligotype: command not found", then it is possible that your path to the oligotyping package is incorrect.  Therefore, we need to fix our path.  To do so we will edit the .bash_profile file in our home directory.

In your current directory type:
```
cd 	#This will take you to your *home* directory
ls -a 	#Show all files in your home directory, including hidden ones (like your .bash_profile file!)
```
Then under the line that includes "PATH=$PATH:$HOME/bin" that you have the following:
```R
export PATH=/home/rprops/.local/bin:/:$PATH  # Be sure to change "rprops" to YOUR USER NAME!
```
If you do not have the above line, please edit it with nano:

```
nano .bash_profile
```

#  Load modules
```
module load mothur R ncbi-blast
```

# Copy mothur.batch.taxass in your folder with the fastq files
**Make sure the sample names of your fastq files are correct, no ':', '-' or '/' !**
In case you have to rename your files adapt the following code line:
```
find /scratch/vdenef_fluxm/rprops/process2/UM_ML14 -type f -exec rename '-' '' {} \;
```
This will remove "-" from your sample names. You may have to run rerun this several times if you have multiple "-" in your sample names.

# Run this piece of code to select for a taxon of interest to perform oligotyping analysis on
**If you want to oligotype everything do not run this.** 
Replace <code> Bacteria;Proteobacteria;Betaproteobacteria;Burkholderiales;betI;betI_A </code> with your taxon of interest.
```
sed -i "s/Bacteria/Bacteria;Proteobacteria;Betaproteobacteria;Burkholderiales;betI;betI_A/g" mothur.batch.taxass
```
# Make stability file
Should you get an error during <code>make.contigs</code> then check if the &#95;R1&#95; and &#95;R2&#95; pattern does not occur in the sample name.
```
paste <(ls *_R1_*.fastq | awk -F"_" '{print $1}') <(ls *_R1_*.fastq) <(ls *_R2_*.fastq) > stability.file
```

# To make sure that you don't have hidden characters (i.e. from Windows)
```
dos2unix mothur.batch.taxass
dos2unix mothur.batch.taxass.pbs
```
# Run batch script
```
mothur mothur.batch.taxass
```
# or all the above as a pbs script
```
qsub mothur.batch.taxass.pbs
```
