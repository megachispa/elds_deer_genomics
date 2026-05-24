#!/bin/bash
#SBATCH --job-name=gemo
#SBATCH --output=gemo_%j.out
#SBATCH --error=gemo_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate gemoma_env

#GeMoMaPipeline run with a single reference genome and annotation

THREADS=8

WORKDIR=/mnt/tank/scratch/ebarabanova/annotation
OUTDIR=$WORKDIR/gemoma_output

mkdir -p "$OUTDIR"
cd $WORKDIR

# Paths to target and reference genomes and annotation
TARGET_GENOME="/nfs/home/ebarabanova/bwa_indexed_ref_genome/GCA_034233915.1_ASM3423391v1_genomic.fna"
REF_GENOME="/mnt/tank/scratch/ebarabanova/annotation/white_tailed_deer/GCF_002102435.1_Ovir.te_1.0_genomic.fna"
REF_ANNOTATION="/mnt/tank/scratch/ebarabanova/annotation/white_tailed_deer/GCF_002102435.1_Ovir.te_1.0_genomic.gff"

# Run GeMoMaPipeline
java -Xmx60G -jar /nfs/home/ebarabanova/miniconda3_new/envs/gemoma_env/share/gemoma-1.9-0/GeMoMa-1.9.jar CLI GeMoMaPipeline \
  threads=$THREADS \
  outdir=$OUTDIR \
  GeMoMa.Score=ReAlign \
  AnnotationFinalizer.r=NO \
  o=true \
  t=$TARGET_GENOME \
  s=own \
  i=ref1 \
  a=$REF_ANNOTATION \
  g=$REF_GENOME
