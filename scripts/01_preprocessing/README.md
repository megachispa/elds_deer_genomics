# 01_preprocessing

This directory contains scripts for preprocessing raw whole-genome sequencing (WGS) data from Siamese Eld's deer (*Rucervus eldii siamensis*). The workflow generates high-quality, alignment-ready BAM files and performs initial sequencing quality control prior to downstream analyses.

---

## Workflow Overview

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_fastqc_multiqc.slurm` | Raw read quality assessment using FastQC and summary reporting with MultiQC |
| 2 | `02_fastqscreen.slurm` | Screening for contamination using FastQ Screen |
| 3 | `03_bwa_align.slurm` | Alignment to reference genome using BWA-MEM |
| 4 | `04_mark_duplicates.slurm` | Marking PCR/optical duplicates using Picard MarkDuplicates |
| 5 | `05_flagstat.slurm` | Alignment statistics using Samtools flagstat |
| 6 | `06_wgs_metrics.slurm` | Genome-wide coverage and alignment metrics using Picard CollectWgsMetrics |
| 7 | `07_multiqc.slurm` | Aggregated QC reporting using MultiQC |

---

## Outputs

The preprocessing pipeline produces:

- Aligned BAM files  
- Duplicate-marked BAM files  
- Mapping and alignment statistics  
- Genome coverage metrics  
- Comprehensive QC reports (FastQC, FastQ Screen, MultiQC)

These outputs are used as input for downstream analyses:

- [`02_vcf_processing`](../02_vcf_processing/)
- [`03_population_genomics`](../03_population_genomics/)

---

## Software

- FastQC  
- MultiQC  
- FastQ Screen  
- BWA  
- Samtools  
- Picard  

---

## Notes

All scripts are designed for execution on HPC systems using **SLURM**.
