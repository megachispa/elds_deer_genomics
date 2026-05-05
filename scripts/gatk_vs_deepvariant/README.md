# GATK vs DeepVariant VCF Comparison Pipeline

This module contains scripts for comparative analysis of variant call sets generated using two different variant callers:
- GATK (Genome Analysis Toolkit)
- DeepVariant

The goal is to assess concordance between the two pipelines and quantify shared and caller-specific variants after standardized filtering.

---

## 🧬 Overview of the pipeline

The analysis follows a reproducible multi-step workflow:

### 1. VCF normalization
- Left-aligns indels and splits multiallelic sites
- Ensures consistent variant representation across datasets
- Tool: `bcftools norm`

### 2. SNP and biallelic filtering
- Retains only SNP variants
- Restricts to biallelic sites (removes complex alleles)

### 3. Missingness filtering
- Removes variants with high proportions of missing genotypes
- Threshold: `--max-missing 0.8` (VCFtools)

### 4. Intersection analysis
- Performed using `bcftools isec`
- Identifies:
  - Shared variants between datasets
  - GATK-private variants
  - DeepVariant-private variants

### 5. Summary statistics
Computed metrics include:
- Total variant counts
- Shared and private variant counts
- Jaccard similarity index
- Proportions of shared/private variants
- Transition/transversion (Ts/Tv) ratios

---

## 📊 Outputs

The pipeline generates:

- `isec_output/`
  - `0000.vcf` → variants unique to GATK
  - `0001.vcf` → variants unique to DeepVariant
  - `0002.vcf` → shared variants

- `stats_report.txt`
  - Summary statistics of concordance analysis

---

## ⚙️ Requirements

- bcftools
- vcftools
- bgzip / tabix
- conda environment: `vcf_clean`


Generated as part of VCF QC and comparative analysis workflow.
