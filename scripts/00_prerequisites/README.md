# Prerequisites

This directory contains scripts used to prepare a custom SnpEff database for Siamese Eld's deer (*Rucervus eldii siamensis*).

## Scripts

- **prepare_snpeff_database.sh**  
  Copies the reference genome and gene annotation files into the SnpEff data directory and registers the custom genome in the SnpEff configuration file.

- **build_snpeff_database.slurm**  
  Builds the SnpEff database from the reference genome and GFF3 annotation using the `snpEff build` command.

## Input files

- Reference genome (FASTA)
- Gene annotation (GFF3)

## Output

- Custom SnpEff database for variant effect prediction.
