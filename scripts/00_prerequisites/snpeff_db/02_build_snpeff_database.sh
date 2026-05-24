#!/bin/bash
#SBATCH --job-name=build_snpeff_db
#SBATCH --output=build_snpeff_db_%j.out
#SBATCH --error=build_snpeff_db_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

set -euo pipefail

# activate conda environment
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate snpeff_env

# build snpEff database
snpEff build -gff3 -v -noCheckCds -noCheckProtein deer
