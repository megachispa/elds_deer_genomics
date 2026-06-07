#!/bin/bash
#SBATCH --job-name=fastqscreen
#SBATCH --output=fastqscreen_%j.out
#SBATCH --error=fastqscreen_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate qc

INPUT_DIR=/mnt/archive/azhuk/reads
OUTPUT_DIR=/mnt/tank/scratch/ebarabanova/quality_control/fastqscreen

mkdir -p "$OUTPUT_DIR"

for fq in "$INPUT_DIR"/*.fastq.gz
do
    fastq_screen \
    --conf /nfs/home/ebarabanova/FastQ_Screen_Genomes/fastq_screen.conf \
    --outdir "$OUTPUT_DIR" \
    "$fq"
done
