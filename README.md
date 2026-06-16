# Conservation Genomics of Siamese Eld's Deer

This repository contains scripts used for the analysis of whole-genome sequencing data from a captive population of Siamese Eld's deer (*Rucervus eldii siamensis*).

## Project goals

- Assess genetic diversity
- Characterize inbreeding using runs of homozygosity (ROH)
- Evaluate relatedness among individuals
- Identify putatively deleterious variants common for the population

## Workflow

### 00_prerequisites
Preparation of software environments and reference resources.

### 01_preprocessing
Quality control, contamination screening, read alignment, duplicate marking, and alignment quality assessment.

### 02_vcf_processing
Variant calling, genotyping, and variant filtering.

### 03_population_genomics
Population genetic analyses including heterozygosity, nucleotide diversity, PCA, ADMIXTURE, and private allele analyses.

### 04_roh_analysis
Detection and characterization of runs of homozygosity.

### 05_gene_annotation
Functional annotation of variants and identification of candidate deleterious mutations.

## Software

- FastQC
- MultiQC
- FastQ Screen
- BWA
- Samtools
- Picard
- GATK
- VCFtools
- PLINK
- ADMIXTURE
- SnpEff

