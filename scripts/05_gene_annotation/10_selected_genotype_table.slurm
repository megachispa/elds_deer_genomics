#!/bin/bash
#SBATCH --job-name=selected_genes_table
#SBATCH --output=selected_genes_table_%j.out
#SBATCH --error=selected_genes_table_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

set -euo pipefail

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

VCF="high_impact_genomewide.vcf.gz"
MAP="gene_names.tsv"

GENE_IDS="gene_8882|gene_22384|gene_10659|gene_6647|gene_8252"

echo "1. Extract sample names"
bcftools query -l "$VCF" > samples.txt
sed -i 's/\r$//' samples.txt

echo "2. Extract variant + annotation"
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%INFO/ANN\n' "$VCF" > tmp.tsv

echo "3. Extract genotypes"
bcftools query -f '[\t%GT]\n' "$VCF" > gt.tsv

echo "4. Build header (without ANN)"
{
  printf "Scaffold\tPosition\tREF→ALT\tEffect\tGene\t"
  paste -sd '\t' samples.txt
} > header.txt

echo "5. Combine raw table"
paste tmp.tsv gt.tsv > body.tsv

echo "6. Filter lines with gene IDs and format output"
grep -E "$GENE_IDS" body.tsv | awk -v mapfile="$MAP" '
BEGIN {
    # Read mapping file: gene_id -> gene_name (strip ref1_gene- prefix)
    while ((getline < mapfile) > 0) {
        id = $1;
        name = $2;
        gsub(/\r$/, "", name);
        sub(/^ref1_gene-/, "", name);
        id_to_name[id] = name;
    }
    close(mapfile);
}
{
    # Columns: 1=CHROM, 2=POS, 3=REF, 4=ALT, 5=ANN, 6..=genotypes
    chrom = $1;
    pos = $2;
    ref = $3;
    alt = $4;
    ann = $5;
    
    # Extract gene ID from ANN using regex
    if (match(ann, /gene_[0-9]+/)) {
        gid = substr(ann, RSTART, RLENGTH);
    } else {
        gid = "unknown";
    }
    
    # Look up gene name
    if (gid in id_to_name) {
        gene = id_to_name[gid];
    } else {
        gene = gid;
    }
    
    # Extract effect from ANN (field 2 = annotation, plus protein change if present)
    split(ann, a, "|");
    effect = a[2];   # e.g., "stop_gained", "splice_acceptor"
    # Try to get protein change (field 11 = HGVS.p)
    if (length(a) >= 12) {
        prot = a[11];   # 0-based: 0=Allele, 1=Annotation, 2=Impact, 3=Gene_ID, 4=Gene_Name, 5=Feature, 6=Transcript, 7=Biotype, 8=Rank, 9=HGVS.c, 10=HGVS.p, 11=cDNA.pos, 12=CDS.pos, 13=AA.pos
        if (prot != "" && prot != "-") {
            effect = effect " (" prot ")";
        }
    }
    
    # Build REF→ALT string
    ref_alt = ref "→" alt;
    
    # Print all genotypes (columns 6 to NF)
    genotypes = "";
    for (i = 6; i <= NF; i++) {
        if (i > 6) genotypes = genotypes "\t";
        genotypes = genotypes $i;
    }
    
    # Output: Scaffold, Position, REF→ALT, Effect, Gene, genotypes
    print chrom "\t" pos "\t" ref_alt "\t" effect "\t" gene "\t" genotypes;
}
' > genotypes_data.tsv

# Combine header and data
cat header.txt genotypes_data.tsv > genotypes_selected_clean.tsv

# Clean up temporary files
rm tmp.tsv gt.tsv body.tsv header.txt genotypes_data.tsv

echo "DONE"
echo "Output: genotypes_selected_clean.tsv"
echo "Total rows (including header): $(wc -l < genotypes_selected_clean.tsv)"
