# BAMtobigWig
Step 1:

BigWig conversion requires BAM files to be sorted and indexed by coordinates.
samtools sort -o sorted.bam input.bam
samtools index sorted.bam

for bam in *.bam; do
    samtools sort -o ${bam%.bam}.sorted.bam $bam
    samtools index ${bam%.bam}.sorted.bam
done

If there are mutiple bam files merge them into one merged.bam
samtools merge merged.bam *.sorted.bam
samtools index merged.bam


Generate bigWig using bamCoverage or bedtools genomecov
bamCoverage -b merged.bam -o merged.bw --binSize 10 --normalizeUsing RPKM
Other normalization options:
--normalizeUsing RPKM (Reads Per Kilobase per Million)
--normalizeUsing CPM (Counts Per Million)
--normalizeUsing BPM (Bins Per Million)
--normalizeUsing RPGC (Reads Per Genomic Content)

bedtools genomecov -ibam merged.bam -bg > merged.bedgraph

Convert bedGraph to bigWig (requires chromosome sizes file):
fetchChromSizes hg38 > genome.chrom.sizes  # Replace hg38 with your genome
bedGraphToBigWig merged.bedgraph genome.chrom.sizes merged.bw

Step 4: Verify the bigWig File
Check if the bigWig was successfully created:

bash
Copy
Edit
bigWigInfo merged.bw
