# 04_roh_analysis

This directory contains scripts for detecting and analyzing Runs of Homozygosity (ROH) in Siamese Eld's deer (*Rucervus eldii siamensis*) using a filtered whole-genome SNP dataset.

The analyses include ROH detection, summary statistics, genomic distribution of ROH islands, estimation of inbreeding coefficients (FROH), and pairwise sharing of ROH segments between individuals.

---

## Workflow Overview

### 1. ROH Detection and Basic Summaries

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_plink_count_roh.slurm` | Convert VCF to PLINK format and detect ROHs using sliding window approach |
| 2 | `02_roh_summary_table.slurm` | Summarize ROH lengths per individual and classify ROH size bins |
| 3 | `03_roh_stacked_plot.R` | Generate stacked barplot of ROH length distributions |
| 4 | `04_roh_stacked_plot.slurm` | SLURM wrapper for ROH stacked plot generation |

---

### 2. Inbreeding and ROH Metrics

| Step | Script | Description |
|------|--------|-------------|
| 5 | `05_froh_gt1Mb.slurm` | Calculate inbreeding coefficient (FROH) using ROH > 1 Mb and genome size normalization |

---

### 3. ROH Islands Detection

| Step | Script | Description |
|------|--------|-------------|
| 6 | `06_roh_islands.slurm` | Identify genomic windows enriched for ROH (ROH islands) using 50 kb windows |
| 7 | `07_largest_island_rohs.slurm` | Extract ROHs overlapping the largest ROH island |
| 8 | `08_plot_largest_island.R` | Plot ROH distribution across the largest island |
| 9 | `09_plot_largest_island.slurm` | SLURM wrapper for island plotting |

---

### 4. Pairwise ROH Sharing

| Step | Script | Description |
|------|--------|-------------|
| 10 | `10_pairwise_overlap_matrix.slurm` | Compute pairwise overlap of ROH segments between individuals |
| 11 | `11_heatmap.R` | Generate heatmap of shared ROH regions |
| 12 | `12_heatmap.slurm` | SLURM wrapper for heatmap generation |

---

## Key Analyses

### ROH Detection
ROHs are detected using PLINK with:
- 50 SNP sliding windows
- Minimum 100 kb ROH length threshold
- Density and gap filters to reduce false positives

### Inbreeding Coefficient (FROH)
Calculated as:

\[
F_{ROH} = \frac{\text{Total length of ROH > 1 Mb}}{\text{Total genome size}}
\]

### ROH Islands
Genomic regions enriched for ROHs are identified using:
- 50 kb non-overlapping windows
- Frequency threshold across individuals
- Merging adjacent enriched windows

### Pairwise ROH Sharing
- Computes overlapping ROH segments between all individuals
- Produces a symmetric distance/relatedness matrix
- Visualized as clustered heatmap

---

## Software

- PLINK v1.9  
- BEDTools  
- VCFtools  
- awk  
- R  
- ggplot2  
- pheatmap  
