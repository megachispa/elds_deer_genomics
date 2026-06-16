# 02_vcf_processing

This directory contains scripts for variant calling, filtering, and quality control of whole-genome sequencing (WGS) data from Siamese Eld's deer (*Rucervus eldii siamensis*). The workflow generates high-quality, filtered VCF datasets for downstream population genomic analyses.

---

## Workflow Overview

### 01_generate_vcf

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_generate_gvcf.slurm` | Generation of per-sample gVCFs using GATK HaplotypeCaller |
| 2 | `02_combine_gvcf.sh` | Combination of individual gVCFs into a cohort-level dataset |
| 3 | `03_genotype_gvcf.slurm` | Joint genotyping to produce a raw cohort VCF |

---

### 02_filter_vcf

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_two_step_filtering.slurm` | Site-level filtering following GATK best practices + genotype level filtering with different combinations of DP and GQ filters |
| 2 | `02_dp8_gq20_filtering.slurm` | Genotype-level filtering with DP ≥ 8 and GQ ≥ 20 filters |

---

### 03_vcf_qc

| Script | Description |
|--------|-------------|
| `dp_4panel.slurm` | Visualization of depth distributions across raw and filtered VCF datasets |
| `multiqc_vcf.slurm` | Aggregated QC reporting for VCF-level statistics |
| `tables.slurm` | Generation of summary tables for variant statistics |

---

### 04_gatk_vs_deepvariant

| Step | Script | Description |
|------|--------|-------------|
| 1 | `01_intersection_raw.slurm` | Comparison of raw variant calls between GATK and DeepVariant |
| 2 | `02_intersection_filtered.slurm` | Comparison after standard filtering |
| 3 | `03_intersection_filtered_missingness.slurm` | Comparison including missingness filtering |
| 4 | `04_intersection_dp8gq20.slurm` | Comparison of datasets processed with selected filters (DP ≥ 8 / GQ ≥ 20) compared with the DeepVariant-filtered dataset |

---

### 05_missingness

| Script | Description |
|--------|-------------|
| `01_compute_missingness.slurm` | Annotation of site-level missingness (F_MISSING) using bcftools and summary of missingness distribution |
| `02_filter_high_missingness.slurm` | Filtering of sites with high missingness (F_MISSING > 0.375), retaining high-completeness variants |

---

## Software

- GATK  
- BCFtools / VCFtools  
- MultiQC   

---

## Notes

All scripts are designed for execution on HPC systems using **SLURM**, except where shell scripts (`.sh`) are indicated.
