library("phyloseq")
library("data.table")
library("splitstackshape")
userprefs <- commandArgs(trailingOnly = TRUE)
mo.data <- userprefs[1]
mo.tax <- userprefs[2]
oligo.data <- userprefs[3]
oligo.tax <- userprefs[4]

cat(paste0(date(),"\tMaking mothur phyloseq object\n"))

### Make mothur phyloseq object
phy.m <- import_mothur(mothur_shared_file = mo.data,
                                     mothur_constaxonomy_file = mo.tax)
### Make oligotyping phyloseq object
cat(paste0(date(),"\tMaking MED phyloseq object\n"))
data.med <- data.frame(fread(input=oligo.data))
colnames(data.med) <- data.med[1,]; rownames(data.med) <- data.med[,1]
data.med <- data.med[-1,];data.med <- data.med[,-1]
tax.med <- data.frame(fread(input = oligo.tax, header = FALSE))
tax.med <- data.frame(cSplit(indt = tax.med, splitCols = "V1", sep = "|", drop = TRUE))
tax.med <- tax.med[,-3]
tax.med <- data.frame(cSplit(indt = tax.med, splitCols = "V2", sep = ";", drop = TRUE))
rownames(tax.med) <- tax.med$V1_1; tax.med <- tax.med[,-1]
colnames(tax.med) <- c("kingdom","phylum","class","order","family","clade","tribe")
inter <- rownames(tax.med)
tax.med <- t(do.call(rbind,lapply(tax.med, as.character)))
rownames(tax.med) <- inter
phy.o <- phyloseq(otu_table(data.med,taxa_are_rows=FALSE),tax_table(tax.med))

cat(paste0(date(),"\tExporting data to Phyloseq.RData\n"))
save(list=c("phy.m","phy.o"), file=paste0("Phyloseq.RData"))
cat(paste0(date(),"\tDone!\n"))

