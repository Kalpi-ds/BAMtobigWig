#!/bin/bash
set -e  

# path to the genome.chrom.sizes file
GENOME_SIZES="/path/to/genome.chrom.sizes"

# Step 1: Sort and index all BAM files
for bam in *.bam; do
    sorted_bam="${bam%.bam}.sorted.bam"
    
    # Sort and index BAM
    samtools sort -o "$sorted_bam" "$bam"
    samtools index "$sorted_bam"
done

# Step 2: Generate bedGraph and BigWig
for bam in *.sorted.bam; do
    bedgraph_out="${bam%.sorted.bam}.bedgraph"
    sorted_bedgraph_out="${bedgraph_out}.sorted"
    bigwig_out="${bam%.sorted.bam}.bw"

    # Generate bedGraph
    bedtools genomecov -ibam "$bam" -bg > "$bedgraph_out"

    # Sort the bedGraph file
    sort -k1,1 -k2,2n "$bedgraph_out" > "$sorted_bedgraph_out"

    # Convert sorted bedGraph to BigWig
    bedGraphToBigWig "$sorted_bedgraph_out" "$GENOME_SIZES" "$bigwig_out"

    # Remove intermediate files
    rm "$bedgraph_out" "$sorted_bedgraph_out"
done

echo "Processing complete!"
/bio/data/Genomes/Hs/hg38.p12/hg38.p12.chrom.sizes