#featureCounts 
count_matrix <- featureCounts(
  files = "SRR4785819Normal.BAM",
  annot.ext = "genomic.gtf",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE, 
  GTF.attrType = "gene_id",
  useMetaFeatures = TRUE
)

allsamples <- c("SRR4785819Normal.BAM", "SRR4785820Normal.BAM", "SRR4785828Normal.BAM", "SRR4785831Normal.BAM", "SRR4785979RA.BAM", "SRR4785980RA.BAM", "SRR4785986RA.BAM", "SRR4785988RA.BAM")

count_matrix <- featureCounts(
  files = allsamples,
  annot.ext = "genomic.gtf",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = TRUE
)

str(count_matrix)
counts <- count_matrix$counts
head(counts)
colnames(counts) <- c("SRR19Normal", "SRR20Normal", "SRR28Normal", "SRR31Normal", "SRR79RA", "SRR80RA", "SRR86RA", "SRR88RA")
head(counts)
write.csv(counts, "human_countmatrix.csv")