#Go analyse
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("goseq")
BiocManager::install("geneLenDataBase")
BiocManager::install("org.Hs.eg.db")
BiocManager::install("GO.db")

library("goseq")
library("geneLenDataBase")
library("org.Hs.eg.db")
library("GO.db")

#Zorg dat je CSV bestand in je working directory staat
counts <- read.csv("count_matrix_RA.txt", row.names = 1)
head(counts)
colnames(counts)

#Filter significante genen
#padj <0.05
#absolute log2FC > 1
deg <- resultaten[
  complete.cases(resultaten[, c("padj", "log2FoldChange")]) &
    resultaten$padj < 0.05 &
    abs(resultaten$log2FoldChange) > 1,
]

dds <- DESeq(dds)
resultaten <- results(dds)

resultaten_clean <- resultaten[
  complete.cases(resultaten[, c("padj", "log2FoldChange")]),
]

deg <- resultaten_clean[
  resultaten_clean$padj < 0.05 &
    abs(resultaten_clean$log2FoldChange) > 1,
]


#Aantal DEGs bekijken
nrow(deg)


# Alle geteste genen
all.genes <- resultaten_clean$gene

# Alleen significante genen
deg.genes <- deg$gene


#Maak gene vector voor goseq
# 1 = DEG
# 0 = niet significant

gene.vector <- as.integer(all.genes %in% deg.genes)

# Geef gen-ID’s als namen
names(gene.vector) <- all.genes

# Controle
gene.vector <- rownames(deg)
head(gene.vector)

all.genes <- rownames(resultaten_clean)
deg.genes <- rownames(deg)
gene.vector <- as.integer(all.genes %in% deg.genes)
names(gene.vector) <- all.genes
head(gene.vector)
length(gene.vector)
table(gene.vector)

#Je hebt 19.939 genen in totaal
#Daarvan zijn 4.572 DEGs (1 = significant)
#En 15.367 niet‑significant (0)

#Maak een TxDb uit jouw GTF
library(GenomicFeatures)
library(txdbmaker)
txdb <- makeTxDbFromGFF("genomic.gtf", format = "gtf")

#Bereken genlengtes
exons <- exonsBy(txdb, by = "gene")
gene.lengths <- sum(width(reduce(exons)))

head(gene.lengths)
length(gene.lengths)
#lengte = 67512


#dit moet ik doen om de gene.vector en gene.lengths even lang te krijgen, daarna kon ik de code hierboven runnen
common.genes <- intersect(names(gene.vector), names(gene.lengths))
length(common.genes)
gene.vector <- gene.vector[common.genes]
gene.lengths <- gene.lengths[common.genes]
length(gene.vector)
length(gene.lengths)

#GOseq draaien met jouw eigen genlengtes
pwf <- nullp(
  gene.vector,
  bias.data = gene.lengths
)


#Plot bias correctie
plot(pwf$bias.data,
     pwf$pwf,
     xlab = "Gene length",
     ylab = "Probability Weighting Function",
     main = "Gene Length Bias Correction")

#GO enrichment uitvoeren
library("org.Hs.eg.db")

GO.wall <- goseq(
  pwf,
  genome = "hg38",
  id = "geneSymbol"
)

head(GO.wall)

#Multiple testing correction
GO.wall$padj <- p.adjust(
  GO.wall$over_represented_pvalue,
  method = "BH"
)

#Significante GO-termen selecteren
sig.go <- GO.wall[
  GO.wall$padj < 0.05,
]

# Bekijk top resultaten
head(sig.go)

#GO termen leesbaar maken
#Voeg GO term namen toe

sig.go$Term <- NA

for(i in 1:nrow(sig.go)) {
  
  go_id <- sig.go$category[i]
  
  term <- Term(GOTERM[[go_id]])
  
  sig.go$Term[i] <- term
}

# Bekijk resultaten
head(sig.go)


#Sorteer op significantie 
sig.go <- sig.go[
  order(sig.go$padj),
]

head(sig.go)


#Resultaten opslaan
write.csv(
  sig.go,
  "GO_enrichment_results.csv",
  row.names = FALSE
)

#Top GO-termen plotten

top.go <- head(sig.go, 10)

# Barplot

library(ggplot2)

ggplot(top.go, aes(x = Term, y = -log10(padj))) +
  geom_col() +
  coord_flip() +
  labs(x = "GO term", y = "-log10 adjusted p-value") +
  theme_bw()

#GO dotplot 
library(dplyr)
library(ggplot2)

plot.go <- sig.go %>%
  arrange(over_represented_pvalue) %>% 
  slice(1:10) %>% 
  mutate(
    hitsPerc = numDEInCat * 100 / numInCat,
    Term = factor(Term, levels = rev(Term))  # voor mooie volgorde
  ) %>%
  ggplot(aes(
    x = hitsPerc,
    y = Term,
    colour = over_represented_pvalue,
    size = numDEInCat
  )) +
  geom_point() +
  expand_limits(x = 0) +
  labs(
    x = "Hits (%)",
    y = "GO term",
    colour = "p value",
    size = "Count"
  ) +
  scale_colour_continuous(trans = "log10") +
  theme_bw()

plot.go

