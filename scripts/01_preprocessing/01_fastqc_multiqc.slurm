#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --output=fastqc_%j.out
#SBATCH --error=fastqc_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate qc

WORKDIR=/mnt/archive/azhuk/reads
FASTQC_DIR=/mnt/tank/scratch/ebarabanova/quality_control/fastqc
MULTIQC_DIR=/mnt/tank/scratch/ebarabanova/quality_control/multiqc

mkdir -p "$FASTQC_DIR"
mkdir -p "$MULTIQC_DIR"

# Run FastQC on all FASTQ files
fastqc \
    --threads 4 \
    --outdir "$FASTQC_DIR" \
    "$WORKDIR"/*.fastq.gz

# Aggregate FastQC reports with MultiQC
multiqc \
"$FASTQC_DIR" \
--outdir "$MULTIQC_DIR"
