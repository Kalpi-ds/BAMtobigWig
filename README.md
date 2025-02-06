# BAMtobigWig

First validate BAM File Format with samtools
1. Run a quick check using samtools quickcheck:

```
samtools quickcheck your_file.bam
```
If it returns no output, the file is likely fine. If there’s an issue, use samtools view to investigate:

```
samtools view your_file.bam | head
```

2. Check BAM Header
Ensure the BAM file structure is intact:

```
samtools view -H your_file.bam
```

If the output looks normal (starting with @HD, @SQ, etc.), the header is intact.


BAMtobigWig Coversion
**Step 1:**

BigWig conversion requires BAM files to be sorted and indexed by coordinates.

```
samtools sort -o sorted.bam input.bam
samtools index sorted.bam
```
If you have multiple bam files, index them using following loop
```
for bam in *.bam; do
    samtools sort -o ${bam%.bam}.sorted.bam $bam
    samtools index ${bam%.bam}.sorted.bam
done
```

The multiple bam  files could be merged into one based on your preference after sorting.
```
samtools merge merged.bam *.sorted.bam
samtools index merged.bam
```

**Step 2:**
Generate bigWig using bamCoverage or bedtools genomecov
```
bamCoverage -b merged.bam -o merged.bw --binSize 10 --normalizeUsing RPKM
```
Other normalization options:
--normalizeUsing RPKM (Reads Per Kilobase per Million)
--normalizeUsing CPM (Counts Per Million)
--normalizeUsing BPM (Bins Per Million)
--normalizeUsing RPGC (Reads Per Genomic Content)

If you choose to use bedtools genomecov, run the additional step to convert bedGraph to bigWig.
You will need genome.chrom.sizes for this step
```
bedtools genomecov -ibam merged.bam -bg > merged.bedgraph
```
Convert bedGraph to bigWig (requires chromosome sizes file):
```
fetchChromSizes hg38 > genome.chrom.sizes  # Replace hg38 with your genome
bedGraphToBigWig merged.bedgraph genome.chrom.sizes merged.bw
```

**Step 3:** 
Verify the bigWig File
Check if the bigWig was successfully created:

```
bigWigInfo merged.bw
```
