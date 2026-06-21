# 03_population_genomics

This directory contains scripts for assessing genetic diversity and population structure in Siamese Eld's deer (*Rucervus eldii siamensis*) using a filtered whole-genome SNP dataset.

The analyses include estimates of nucleotide diversity, heterozygosity, private alleles, principal component analysis (PCA), and ADMIXTURE clustering.

---

## Workflow Overview

### Diversity Statistics

| Step | Script                     | Description |
|------|----------------------------|-------------|
| 1    | `01_nucleotide_diversity.slurm` | Calculation of nucleotide diversity (π) in 100 kb windows using VCFtools and summarization of mean and median π |
| 2    | `02_heterozygosity.slurm`       | Calculation of individual heterozygosity and inbreeding coefficient (F) using VCFtools |
| 3    | `03_private_vcftools.slurm`     | Identification of strict private alleles (singletons) and summarization of private allele counts per individual |

---

### Population Structure

| Step | Script              | Description |
|------|---------------------|-------------|
| 1    | `04_pca.slurm`      | Conversion of VCF to PLINK format, LD pruning, and principal component analysis (PCA) |
| 2    | `05_plot_pca.R`     | Visualization of PCA results (PC1 vs PC2) using ggplot2 |
| 3    | `06_plot_pca.slurm` | SLURM wrapper for PCA plotting |
| 4    | `07_admixture.slurm`| ADMIXTURE analysis (K = 1–5) using an LD-pruned SNP dataset and collection of cross-validation errors |

---

## Software

- VCFtools  
- PLINK v1.9  
- ADMIXTURE  
- R  
- ggplot2  
- ggrepel  
