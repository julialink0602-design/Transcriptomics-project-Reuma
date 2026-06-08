#aligment
setwd("C:/Users/startklaar/OneDrive - NHL Stenden/Jaar 2/Periode 4/Transcriptomics/Project")
getwd()
library(Rsubread)
browseVignettes('Rsubread')

buildindex(
  basename = 'ref_human',
  reference = 'GCF_000001405.40_GRCh38.p14_genomic.fna',
  memory = 4000,
  indexSplit = TRUE)

align.srr5819 <- align(index = "ref_human",
                       readfile1 = "SRR4785819_1_subset40k.fastq",
                       readfile2 = "SRR4785819_2_subset40k.fastq",
                       output_file = "SRR4785819Normal.BAM")

align.srr5820 <- align(index = "ref_human",
                       readfile1 = "SRR4785820_1_subset40k.fastq",
                       readfile2 = "SRR4785820_2_subset40k.fastq",
                       output_file = "SRR4785820Normal.BAM")

align.srr5828 <- align(index = "ref_human",
                       readfile1 = "SRR4785828_1_subset40k.fastq",
                       readfile2 = "SRR4785828_2_subset40k.fastq",
                       output_file = "SRR4785828Normal.BAM")

align.srr5831 <- align(index = "ref_human",
                       readfile1 = "SRR4785831_1_subset40k.fastq",
                       readfile2 = "SRR4785831_2_subset40k.fastq",
                       output_file = "SRR4785831Normal.BAM")

align.srr5979 <- align(index = "ref_human",
                       readfile1 = "SRR4785979_1_subset40k.fastq",
                       readfile2 = "SRR4785979_2_subset40k.fastq",
                       output_file = "SRR4785979RA.BAM")

align.srr5980 <- align(index = "ref_human",
                       readfile1 = "SRR4785980_1_subset40k.fastq",
                       readfile2 = "SRR4785980_2_subset40k.fastq",
                       output_file = "SRR4785980RA.BAM")

align.srr5986 <- align(index = "ref_human",
                       readfile1 = "SRR4785986_1_subset40k.fastq",
                       readfile2 = "SRR4785986_2_subset40k.fastq",
                       output_file = "SRR4785986RA.BAM")

align.srr5988 <- align(index = "ref_human",
                       readfile1 = "SRR4785988_1_subset40k.fastq",
                       readfile2 = "SRR4785988_2_subset40k.fastq",
                       output_file = "SRR4785988RA.BAM")

# Laad Rsamtools voor sorteren en indexeren (dowloaden indien nodig)
BiocManager::install('Rsamtools')
library(Rsamtools)

# Bestandsnamen van de monsters
samples <- c('SRR4785819Normal', 'SRR4785820Normal', 'SRR4785828Normal', 'SRR4785831Normal', 'SRR4785979RA', 'SRR4785980RA', 'SRR4785986RA', 'SRR4785988RA')

# Voor elk monster: sorteer en indexeer de BAM-file
# Sorteer BAM-bestanden
lapply(samples, function(s) {sortBam(file = paste0(s,'.BAM' ), destination = paste0(s, '.sorted'))
})
# Indexeer de gesorteerde BAM-file
lapply(samples, function(s) {indexBam(file = paste0(s, '.sorted.bam'))
})