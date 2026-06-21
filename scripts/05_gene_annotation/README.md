# 05_gene_annotation

This directory contains scripts for genome annotation and functional interpretation of SNPs in Siamese Eld's deer (*Rucervus eldii siamensis*).

Analyses include gene annotation transfer, SNP functional classification (genic vs intergenic, CDS, intronic), SNP density estimation, variant effect prediction, identification of high-impact mutations, and integration with ROH data.

---

## Workflow Overview

### 1. Genome Annotation (GeMoMa)

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_gemoma.slurm` | Gene annotation transfer using GeMoMa with white-tailed deer reference genome |

---

### 2. Variant Localization (Genic vs Intergenic)

| Step | Script | Description |
|------|--------|-------------|
| 2 | `02_variants_invsout.slurm` | Classify SNPs as genic vs intergenic using BEDTools |
| 3 | `03_variant_densities.slurm` | Calculate SNP counts and densities in CDS, intronic, genic, and intergenic regions |

---

### 3. Genome-wide Functional Annotation

| Step | Script | Description |
|------|--------|-------------|
| 4 | `04_annotate_all_variants.slurm` | Annotate full VCF using snpEff and extract high-impact variants |

---

### 4. High-impact Variant Summaries

| Step | Script | Description |
|------|--------|-------------|
| 5 | `05_high_per_sample.slurm` | Count high-impact variants per individual (heterozygous vs homozygous) |
| 6 | `06_high_genomewide.slurm` | Rank high-impact variants and summarize genome-wide distribution |

---

### 5. Deleterious Variant Analysis

| Step | Script | Description |
|------|--------|-------------|
| 7 | `07_stop_gained_roh_or_not.slurm` | Identify stop-gained variants and test whether they fall within ROH regions |
| 8 | `08_plot_stop_gained.R` | Visualize distribution of stop-gained variants in non-ROH regions vs ROH regions |
| 9 | `09_plot_stop_gained.slurm` | SLURM wrapper for plotting |

---

### 6. Targeted Gene Extraction

| Step | Script | Description |
|------|--------|-------------|
| 10 | `10_selected_genotype_table.slurm` | Extract genotypes for selected high-impact genes of interest |

---
## Software

- GeMoMa  
- snpEff  
- VCFtools  
- BEDTools  
- bcftools  
- awk  
- R  
- ggplot2  
- dplyr (implicit in R workflows)  
