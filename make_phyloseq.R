# Why this script?  
##  Create a .RData file with 2 phyloseq objects (mothur & oligotyping output) for input into R
### 1. Phyloseq object with OTU (mothur) data (called phy.otu)
### 2. Phyloseq object with oligotyping data (called phy.oligo)
# Where:  Run on flux in the shell (after you have ran mothur and oligotyping) 

## Load the R-packages necessary for the script below to run
library("phyloseq")
library("data.table")
library("splitstackshape")

## 
userprefs <- commandArgs(trailingOnly = TRUE)
mo.data <- userprefs[1]
mo.tax <- userprefs[2]
oligo.data <- userprefs[3]
oligo.tax <- userprefs[4]

# Write an update in the commandline that the script is working...
cat(paste0(date(),"\tMaking mothur phyloseq object\n"))

### Make 1mothur phyloseq object
phy.otu <- import_mothur(mothur_shared_file = mo.data,
                                     mothur_constaxonomy_file = mo.tax)
### Make oligotyping phyloseq object 
cat(paste0(date(),"\tMaking MED phyloseq object\n")) # Update user that R is working
data.oligo <- data.frame(fread(input=oligo.data)) # read in the oligotyping file to R as a data frame
colnames(data.oligo) <- data.oligo[1,]; rownames(data.oligo) <- data.oligo[,1]  # Make the 1st row and 1st column of the data frame the rownames and column names
data.oligo <- data.oligo[-1,];data.oligo <- data.oligo[,-1] # remove the first row (now redundant with column and row names)
tax.oligo <- data.frame(fread(input = oligo.tax, header = FALSE))
tax.oligo <- data.frame(cSplit(indt = tax.oligo, splitCols = "V1", sep = "|", drop = TRUE))
tax.oligo <- tax.oligo[,-3]
tax.oligo <- data.frame(cSplit(indt = tax.oligo, splitCols = "V2", sep = ";", drop = TRUE))
rownames(tax.oligo) <- tax.oligo$V1_1; tax.oligo <- tax.oligo[,-1]
colnames(tax.oligo) <- c("kingdom","phylum","class","order","family","clade","tribe") # Rename the columns in the tax file to represent taxonomic ranks
inter <- rownames(tax.oligo)
tax.oligo <- t(do.call(rbind, lapply(tax.oligo, as.character)))
rownames(tax.oligo) <- inter
phy.oligo <- phyloseq(otu_table(data.oligo,taxa_are_rows=FALSE),tax_table(tax.oligo)) # Combine everything into a phyloseq Object called phy.o

# Finalize script
cat(paste0(date(),"\tExporting data to Phyloseq.RData\n")) # Update user that .Rdata is being exported
save(list=c("phy.otu","phy.oligo"), file=paste0("Phyloseq.RData")) # Create a new file called "Phyloseq.RData" that has the phyloseq object
cat(paste0(date(),"\tDone! Time to work on your analysis!\n")) # Script has finished!

# fin

