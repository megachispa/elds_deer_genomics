#!/bin/bash
#SBATCH --job-name=bwa
#SBATCH --output=bwa_%j.out
#SBATCH --error=bwa_%j.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

SAMPLE=$1

OUTPUT_DIR=/mnt/tank/scratch/ebarabanova/bam_files
REF=/nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna
READ_DIR=/mnt/archive/azhuk/reads

mkdir -p "$OUTPUT_DIR"

bwa mem \
    -t 8 \
    -R "@RG\tID:${SAMPLE}\tPL:ILLUMINA\tPU:${SAMPLE}\tLB:${SAMPLE}\tSM:${SAMPLE}" \
    "$REF" \
    "$READ_DIR/${SAMPLE}_1.fastq.gz" \
    "$READ_DIR/${SAMPLE}_2.fastq.gz" | \
samtools view -u - | \
samtools sort -@8 -o "$OUTPUT_DIR/${SAMPLE}.bam"
