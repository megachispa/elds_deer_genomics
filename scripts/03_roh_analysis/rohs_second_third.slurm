#!/bin/bash
#SBATCH --job-name=second_third_rohs
#SBATCH --output=second_third_rohs_%j.out
#SBATCH --error=second_third_rohs_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G

WORKDIR=/mnt/tank/scratch/ebarabanova/roh
cd "$WORKDIR"

second=$(sort -k5,5nr roh_islands_final.txt | sed -n '2p')

scaffold=$(echo "$second" | awk '{print $1}')
start=$(echo "$second" | awk '{print $2}')
end=$(echo "$second" | awk '{print $3}')

echo "$second"

awk -v scaf="$scaffold" -v s="$start" -v e="$end" '
$1==scaf &&
$3>=s &&
$2<=e
' roh_gt1Mb_sorted.bed > second_island_rohs.txt

third=$(sort -k5,5nr roh_islands_final.txt | sed -n '3p')

scaffold=$(echo "$third" | awk '{print $1}')
start=$(echo "$third" | awk '{print $2}')
end=$(echo "$third" | awk '{print $3}')

echo "$third"

awk -v scaf="$scaffold" -v s="$start" -v e="$end" '
$1==scaf &&
$3>=s &&
$2<=e
' roh_gt1Mb_sorted.bed > third_island_rohs.txt
