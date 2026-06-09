#pathway
keggLink("pathway", "hsa:04657")


resultaten2 <- resultaten
resultaten2[1] <- NULL
resultaten2[2:5] <- NULL

pathview(
  gene.data = resultaten2,
  pathway.id = "hsa04657",  
  species = "hsa",          
  gene.idtype = "SYMBOL",     
  limit = list(gene = 5)    
)