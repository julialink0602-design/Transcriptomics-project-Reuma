#DESeq2analyse
counts <- read.table("count_matrix_RA.txt", row.names = 1)

BiocManager::install("DESeq2")
BiocManager::install("KEGGREST")
BiocManager::install("EnhancedVolcano")
BiocManager::install("pathview")

library(DESeq2)
library(KEGGREST)
library(EnhancedVolcano)
library(pathview)

treatment <- c("Normal", "Normal", "Normal", "Normal", "RA", "RA", "RA", "RA")
treatment_table <- data.frame(treatment)
rownames(treatment_table) <- c('SRR19Normal', 'SRR20Normal', 'SRR28Normal', 'SRR31Normal', 'SRR79RA', 'SRR80RA', 'SRR86RA', 'SRR88RA')
treatment_table

# Maak DESeqDataSet aan
colnames(counts) <- c('SRR19Normal', 'SRR20Normal', 'SRR28Normal', 'SRR31Normal', 'SRR79RA', 'SRR80RA', 'SRR86RA', 'SRR88RA')

dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = treatment_table,
                              design = ~ treatment)

# Voer analyse uit
dds <- DESeq(dds)
resultaten <- results(dds)
write.table(resultaten, file = 'ResultatenWC3.csv', row.names = TRUE, col.names = TRUE)
head(resultaten)

sum(resultaten$padj < 0.05 & resultaten$log2FoldChange > 1, na.rm = TRUE)
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange < -1, na.rm = TRUE)

hoogste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = TRUE), ]
laagste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = FALSE), ]
laagste_p_waarde <- resultaten[order(resultaten$padj, decreasing = FALSE), ]

EnhancedVolcano(resultaten,
                lab = rownames(resultaten),
                x = 'log2FoldChange',
                y = 'padj')

dev.copy(png, 'VolcanoplotWC.png', 
         width = 8,
         height = 10,
         units = 'in',
         res = 500)
dev.off()


selectLab = c("BAX", "BCL2A1", "SRGN")
drawConnectors = TRUE
widthConnectors = 0.5
colConnectors = 'grey50'
pCutoff = 0.01
FCcutoff = 1.5
xlim = c(-5, 5)
title = 'Differentiële expressie RA vs Normal'
subtitle = 'DESeq2 analyse'
legendLabels = c('NS', 'Log2FC', 'p-waarde', 'beide')
colAlpha = 0.6
