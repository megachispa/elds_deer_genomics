#!/bin/bash
#SBATCH --job-name=top
#SBATCH --output=top_%j.out
#SBATCH --error=top_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

# Create table with all HIGH-impact variants and genotypes

bcftools query \
    -f '%CHROM\t%POS\t%INFO/ANN[\t%GT]\n' \
    annotated_genomewide.vcf.gz \
| grep '|HIGH|' \
> high_genomewide.tsv

# Count homozygous alternate individuals

awk '
{
    hom=0
    for(i=4;i<=NF;i++)
        if($i=="1/1" || $i=="1|1")
            hom++
    print hom "\t" $0
}
' high_genomewide.tsv \
| sort -k1,1nr \
> high_genomewide_ranked.tsv
