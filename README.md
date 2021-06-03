# To Run:

## 1. Load mothur, R, and ncbi-blast.
```bash
module load Bioinformatics mothur ncbi-blast
```
## 2. create a folder with your fastq files
## 3. **Make sure the sample names of your fastq files are correct. Mothur does **not** accept: ':', '-' or '/' !**
If you have to rename your files, you can run the following line of code:
```bash
find path_to_fastq_files -type f -exec rename '-' '_' {} \;
```
The above code  will remove "-" from your sample names. You may have to run rerun this several times if you have multiple "-" in your sample names.

## 4. To select for a taxon of interest to perform oligotyping analysis on, run the following code after copying mothuyr.batch.taxass to your working directory:
**If you want to oligotype everything do *not* run this.** 

Replace <code> Bacteria;Proteobacteria;Betaproteobacteria;Burkholderiales;betI;betI_A </code> with your taxon of interest.
```
sed -i "s/Bacteria/Bacteria;Proteobacteria;Betaproteobacteria;Burkholderiales;betI;betI_A/g" mothur.batch.taxass
```
If you do this you should change the slurm script or your command to point to this script instead of the default one.

## 5. Make stability file (file with sample names and corresponding fastq files for that sample).
Should you get an error during <code>make.contigs</code> then check if the &#95;R1&#95; and &#95;R2&#95; pattern does not occur in the sample name.
```
paste <(ls path/to/fastq/*_R1_*.fastq | awk -F"_" '{print $1}') <(ls *_R1_*.fastq) <(ls *_R2_*.fastq) > stability.file
```

## 6. You're ready to go!  Option A:  Run the `mothur.batch.taxass` or option B: submit a job to flux with the `mothur.batch.taxass.pbs`.
```bash
mothur /nfs/turbo/lsa-dudelabs/pipelines/Mothur_oligo_batch/mothur.batch.taxass  #Option A
```
### Or
copy /nfs/turbo/lsa-dudelabs/pipelines/Mothur_oligo_batch/mothur_slurm.sh to your working directory
uncomment the corrent mothur workflow you want to use (with or without oligotyping)
change the email to yours
change the account to the appropriate one for your lab
```bash
sbatch mothur_slurm.sh  #Option B
```

## Post Mothur step: Create a phyloseq object with the `make_phyloseq.R` script.
```
Rscript make_phyloseq.R mothur.shared mothur.cons.taxonomy ./stability-m0.10-A0-M0-d4/MATRIX-COUNT.txt ./stability-m0.10-A0-M0-d4/oligo.taxonomy
```
There are 4 inputs in the above code:
 1. mothur `shared` file
 2. mothur `cons.taxonomy` file 
 3. oligotyping `shared` file 
 4. oligotyping `tax` file  
 
You can specify the full path (as above for the oligotyping data which was located in a different folder) or you may write the file names if you are in the same working directory.
