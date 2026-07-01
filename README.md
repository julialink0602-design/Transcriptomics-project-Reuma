J2P4_BM_Transcriptomics_Julia Link_LBM2.C

# Transcriptomics analyse van reumatoïde artritis (RA)
RNA-seq vergelijking tussen RA en gezonde controles met DESeq2, GO/KEGG analyse en in kaart brengen van de IL-17 pathway.

## 📁 Introductie 
Reumatoïde artritis (RA) is een chronische, systemische auto-immuunziekte waarbij het immuunsysteem het eigen gewrichtsweefsel aanvalt. De exacte oorzaak is nog niet volledig bekend, maar een combinatie van genetische factoren, omgevingsinvloeden en een ontregelde immuunrespons speelt een belangrijke rol. (Hitchon & El-Gabalawy, 2011). Een kenmerkend aspect van RA is synovitis: een ontsteking van het gewrichtsslijmvlies die leidt tot pijn, zwelling en uiteindelijk gewrichtsschade. Vroege diagnose en inzicht in de onderliggende moleculaire processen zijn essentieel om progressie te beperken. (Platzer et al., 2019)

In dit project is een transcriptomics-analyse uitgevoerd op RNA-seq data afkomstig uit synoviumbiopten van vier gezonde personen en vier personen met vastgestelde RA (>12 maanden, ACPA-positief). Door middel van bio-informatische analyse worden verschillen in genexpressie onderzocht tussen beide groepen wat ook weergegeven wordt in *Informatie casus RA* in de map **1_Achtergrondinformatie + methode**. Het doel is om inzicht te krijgen in welke genen en biologische processen veranderen bij RA en welke pathways mogelijk betrokken zijn bij de ziekte. De uitkomsten laten zien welke processen in het lichaam anders werken bij reuma, dat geeft meer inzicht in de ziekte en kan helpen bij het zoeken naar nieuwe medicijnen. De accessionnummer van alle gebruikte samples zijn opgenomen in het bestand *Accession nummers* in de map **2_Data/Data_RA_raw**.
___

## 🔬 Methode
De analyse is uitgevoerd in R, waarbij alle onderdelen van de RNA-seq analyse stap voor stap zijn verwerkt zoals het flowschema in figuur 1 . De ruwe RNA‑seq data die in dit project is gebruikt, is afkomstig uit het artikel van Platzer et al. (2019). Het volledige artikel staat in de map **6_Bronnen**. De ruwe FASTQ-bestanden zijn gemapt op het humane referentiegenoom **GRCh38 (GCF_000001405.40_GRCh38.p14)**. Hiervoor is het pakket **Rsubread** (versienummer 2.24.0 | Liao et al. (2019)) gebruikt. Eerst is een index ingebouwd, waarna alle reads van de acht samples zijn uitgelijnd. De resulterende BAM-bestanden zijn gesorteerd en geïndexeerd met **Rsamtools** (versienummer 2.26.0 | Li et al. (2009)).

Vervolgens zijn gen-tellingen gegenereerd met **featureCounts** (versienummer 1.62.0 | Lawrence et al. (2013)), waarbij gebruik gemaakt is van een bijbehorend **genomic.gtf**-annotatiebestand. De count matrix is gebruikt als input voor **DESeq2** (versienummer 1.50.2 | Love, Huber & Anders (2014)), waarmee differentiële genexpressie tussen RA en gezonde controles is bepaald. Hierbij is een model gebruikt met de factor *treatment* (Normal vs RA). De volledige lijst met gebruikte packages met versienummer en wetenschappelijke artikelen wordt weergegeven in *Packages, versienummers en artikelen* in de map **3_R scripts**. 

Na de DESeq2-analyse zijn significante genen geselecteerd op basis van padj <0.05 en |log2FC| >1. Om te zien welke processen in het lichaam anders werken, is er een GO-analyse gedaan. Daarbij is ervoor gezorgd dat langere en kortere genen eerlijk met elkaar vergeleken worden. Daarnaast is er een KEGG-analyse uitgevoerd om betrokken signaalroutes te identificeren.  

<div align="center">
  <img src="1_Achtergrondinformatie + methode/Flowschema van de methode.png" width="600"><br>
  <b>Figuur 1.</b> Flowschema methode van de RNA-seq analyse.
</div>


___

## 📊 Resultaten
Het doel van de transcriptomics analyse was om te bepalen welke genen en biologische processen verschillen in expressie tussen synoviaal weefsel van personen met reumatoïde artritis (RA) en gezonde controles. 
De DESeq2-analyse identificeerde 4572 differentieel tot expressie komende genen (DEGs) tussen RA en gezond, waarvan 2085 verhoogd en 2487 verlaagd. Opvallende genen zoals **BAX**, **BCL2A1**, **SRGN**, **CD28**, **ALPL** en **ADAMTS6** vertoonden een sterke differentiële expressie tussen RA en gezonde controles. In figuur 2 visualiseert de vulcano plot deze veranderingen op basis van log₂ fold change en −log₁₀ p waarde. Voorafgaand aan de GO-analyse werd genlengte-bias gecorrigeerd met GOseq; de bijbehorende plot (*gene length bias correction en proportion DE vs. bias*) zijn beschikbaar in de map **4_Resulaten**. 
De GO-enrichmentanalyse in figuur 3 laat zien dat de DEGs sterk clusteren binnen immuungerelateerde processen, waaronder **immunoglobulin complex**, **adaptive immune response**, **B cell mediated immunity**, **antigen binding**, **leukocyte activation** en **cell activation**.

<table>
  <tr>
    <td align="center">
      <img src="4_Resultaten/VolcanoplotWC.png" height="300"><br>
      <b>Figuur 2.</b> Volcano plot van de DESeq2-analyse (RA vs normaal). 
      Significant gedifferentieerde genen (rood) vallen op door hoge -log₁₀ p-waarden en sterke log₂FC. Opvallende RA-geassocieerde genen zijn o.a. SRGN, CD28, CR1, ALPL en ADAMTS6.
    </td>
    <td align="center">
      <img src="4_Resultaten/GO dotplot.png" height="300"><br>
      <b>Figuur 3.</b> GO-enrichment dotplot van differentieel tot expressie komende genen. 
      Bubbelgrootte = aantal genen, x-as = % hits, kleur = p-waarde. Sterk verrijkte termen zijn o.a immunoglobulin complex, adaptive immune respons en B cell mediated immunity.
    </td>
  </tr>
</table>

De GO-barplot in figuur 4 bevestigt dat vooral humorale en adaptieve immuunroutes significant versterkt zijn, met hoge -log10 adjusted p-waarden voor onder anderen **immunoglobulin mediated immune response, B cell mediated immunity** en **adaptive immune respons**. 

De **IL-17 pathway** is gekozen omdat IL17A een belangrijke drijver is van RA-ontsteking en betrokken is bij de overgang van acute naar chronische gewrichtsschade. Het onderliggende artikel (Lubberts, 2008) staat in de map **6_Bronnen** en beschrijft IL-17-pathway als centraal mechanisme in RA-pathogenese.
De pathview-analyse van het **IL-17-pathway** toont dat meerdere ontstekingsgerelateerde genfamilies sterk geactiveerd zijn. Vooral chemokines (**CXCL1, CXCL2, CXCL5, CXCL8, CXCL10, CCL2, CCL7 en CCL20**) en matrix-metalloproteïnases (**MMP1, MMP3, MMP9 en MMP13**) zijn duidelijk up-gereguleerd, wat wijst op verhoogde immuuncelrekrutering en weefselremodellering bij personen met RA. In de map **4_Resultaten** staat de volledige pathview. Met figuur 5 en tabel 1 is er ingezoomd op het **effector-segment van de IL-17-pathway**, waar de downstream-activatie van *NF‑κB en MAPK* leidt tot expressie van ontstekingsgerelateerde genen. 

<div align="center">
  <img src="4_Resultaten/Barplot .png" width="400"><br>
  <b>Figuur 4.</b> GO-enrichment barplot.
  X-as = -log₁₀ adjusted p-waarde, waarbij langere balken een sterker signaal aangeven. De meest significante GO-termen zijn immunoglobulin complex, B cell mediated immunity en adaptive immune respons.
</div>

<br><br>

<table>
  <tr>
    <td align="center">
      <img src="4_Resultaten/Ingezoomd stukje pathview.png" width="330"><br>
      <b>Figuur 5.</b> Ingezoomd stukje Pathview van de KEGG analyse.
      Chemokines, cytokines, anti-microbieel en tissue remodeling van ingezoomd stukje van de pathview van IL-17.
    </td>
    <td align="center">
      <b>Tabel 1.</b> IL‑17‑doelgenen van ingezoomd stukje Pathview van de KEGG analyse.
      Sterke up-regulatie van chemokines en MMP-genen, cytokines tonen gemengde regulatie.
      <img src="4_Resultaten/Tabel ingezoomd stukje pathview.png" width="600"><br>
    </td>
  </tr>
</table>



___

## 🧠 Conclusie
In deze studie werden transcriptomische verschillen onderzocht tussen synoviaal weefsel van patiënten met reumatoïde artritis (RA) en gezonde controles. De DESeq2-analyse identificeerde duizenden differentieel tot expressie komende genen, aarbij vooral ontstekings- en immuunresponsgenen verhoogd tot expressie kwamen. Opvallende genen zoals SRGN, CD28, CR1, ALPL en ADAMTS6 wijzen op activatie van immuuncellen, cytokinesignalering en weefselremodellering. Daarnaast vertoonden apoptose-gerelateerde genen, waaronder BAX en BCL2A1, veranderingen die passen bij de chronische ontstekingsomgeving van RA.

De GO-analyse bevestigde dat vooral adaptieve en humorale immuunprocessen, waaronder immunoglobuline complex, B-celactivatie en antigen binding, versterkt zijn. De KEGG-analyse liet activiteit zien van belangrijke ontstekingsroutes, waaronder TNF-, NF κB, Toll like receptor en cytokine-cytokine receptor signaleringsroutes. Ook de pathview-analyse van de IL-17 pathway toonde sterke upregulatie van chemokinen en genen betrokken bij neutrofielenrekrutering en synoviale inflammatie. Deze bevindingen sluiten aan bij eerdere studies, waaronder Taams (2020), die benadrukt dat IL-17 een belangrijke bijdrage levert aan synoviale inflammatie, ondanks wisselende klinische respons op IL-17 remmming. 

Een beperking van het onderzoek is de kleine steekproefomvang. Vervolgonderzoek kan zich richten op de validatie van de geïdentificeerde genen en pathways in een grotere patiëntengroep. Hierbij kan worden onderzocht of genen zoals SRGN, CD28, CR1, ALPL en ADAMTS6 bruikbaar zijn als biomarkers voor ziekteactiviteit of behandelingseffect. Dit kan bijdragen aan een betere diagnose en meer gepersonaliseerde behandeling van patiënten met reumatoïde artritis.


