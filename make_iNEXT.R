# Why this script?  

##  OUTPUT:  Create a .RData file with 2 data iNEXT objects (oligotyping & mothur output) for input into R for alpha diversity analysis
### 1. iNEXT.oligo = iNEXT data object with oligotyping table
### 2. iNEXT.otu = iNEXT data object with OTU (mothur) table

## INPUT: Transformed (taxa as rows) OTU and Oligotyping count tables 

# Where:  Run on flux in the shell (after you have ran mothur and oligotyping) 
# Run the script in the same working directory where the data files are available 


## Load the R-packages necessary for the script below to run
library(iNEXT) # iNEXT package for alpha diversity measurements 

###  Set the Preferences  
userprefs <- commandArgs(trailingOnly = TRUE)
oligo.table <- userprefs[1]
otu.table <- userprefs[2]
cutoff <- userprefs[3]

# Write an update in the commandline that the script is working...
cat(paste0(date(),"\Calculating iNEXT Hill Diversity Estimates with Oligotyping data\n"))

### Make Oligotyping  phyloseq object
# Calculate richness, shannon and simpson Hill Diversity estimates with iNEXT function 
iNEXT.oligo <- iNEXT(oligo.table, q = c(0, 1, 2), datatype = "abundance") 

# Compute all Hill Diversity estimates for a particular sample size
oligo.div <- estimateD(oligo.table, datatype = "abundance", base = "size", level = cutoff, conf = 0.95)


# Write an update in the commandline that the script is working...
cat(paste0(date(),"\Calculating iNEXT Hill Diversity Estimates with OTU (mothur) data\n"))

### Make Oligotyping  phyloseq object
iNEXT.otu <- iNEXT(otu.table, q = c(0, 1, 2), datatype = "abundance") # Calculate richness, shannon and simpson Hill Diversity estimates

# Compute all Hill Diversity estimates for a particular sample size
otu.div <- estimateD(otu.table, datatype = "abundance", base = "size", level = cutoff, conf = 0.95)


# Finalize script
cat(paste0(date(),"\tExporting data to iNEXT_otu_oligo.RData\n")) # Update user that .Rdata is being exported
save(list=c("iNEXT.oligo", "oligo.div","iNEXT.otu", "otu.div"), file=paste0("iNEXT_otu_oligo.RData")) # Create a new file called "Phyloseq.RData" that has the phyloseq object
cat(paste0(date(),"\tDone! Time to work on your alpha diversity 9analysis!\n")) # Script has finished!


# SOURCES:
# 1. T. C. Hsieh, K. H. Ma and Anne Chao. 2016 iNEXT: iNterpolation and EXTrapolation for species diversity. R package version 2.0.12 URL:
#  http://chao.stat.nthu.edu.tw/blog/software-download/.
# 2. Anne Chao, Nicholas J. Gotelli, T. C. Hsieh, Elizabeth L. Sander, K. H. Ma, Robert K. Colwell, and Aaron M. Ellison 2014. Rarefaction and
# extrapolation with Hill numbers: a framework for sampling and estimation in species diversity studies. Ecological Monographs 84:45-67.


# fin

