#!/bin/bash
#SBATCH --job-name=highimpact_table
#SBATCH --output=highimpact_table_%j.out
#SBATCH --error=highimpact_table_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

set -euo pipefail

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate snpeff_env

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

VCF="high_impact.vcf"

echo "Extracting HIGH-impact variant annotations..."

# Extract key SnpEff ANN fields
# Fields:
# CHROM POS REF ALT EFFECT HGVS.p GENE

java -jar ~/snpEff/SnpSift.jar extractFields \
-e "." \
-s "," \
"$VCF" \
CHROM \
POS \
REF \
ALT \
"ANN[*].EFFECT" \
"ANN[*].HGVS_P" \
"ANN[*].GENE" \
> high_impact_candidates.tsv

echo "Done."
echo "Output: high_impact_candidates.tsv"

#Extract gene ID → gene name mapping from GFF

awk -F'\t' '$3=="mRNA" {
    match($9,/Parent=([^;]+)/,a)
    match($9,/ref-gene=ref1_gene-([^;]+)/,b)

    if (a[1] != "" && b[1] != "") {
        print a[1] "\t" b[1]
    }
}' top_roh_gene_annotation.gff \
| sort -u > gene_id_to_name.tsv

#Replace ids in the table
awk 'BEGIN{FS=OFS="\t"}
NR==FNR {name[$1]=$2; next}

NR==1 {
    print $0, "Gene_name"
    next
}

{
    gene = ($7 in name ? name[$7] : $7)
    print $0, gene
}' gene_id_to_name.tsv high_impact_candidates.tsv \
> high_impact_candidates_named.tsv
