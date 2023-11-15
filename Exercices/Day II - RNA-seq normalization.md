## RNA-seq normalization - exercises

You will find a gene expression matrix from an RNA-seq experiment investigation the transcriptome response of Arabidopsis thaliana (the plant model) to a flagellin treatment. The flagellin peptide simulates attack from a bacterial pathogen and should trigger a defense response from the plant. Your task is, first, to investigate the data and assess whether the experiment went well.

1. Use the `readxl` library to read the data in R. How many genes have been quantified? How many samples are provided and what is the number of replicates?
2. Assess the distribution of read counts between samples. Using ggplot2, create a density plot showing the distribution for all samples, colored by condition (control vs treatment). You will need to transform the data in long format using `melt()` from the `reshape2` package. What do you observe in the density plot?
3. Building up from the previous plot, add a logarithmic scale for the X-axis. What is the warning message ggplot2 is showing you, and where does it come from?
4. Try to come up with a solution to solve the warning created from the previous plot. Also, provide the plot with a 0.5 figure ratio and all the appropriate labels (title, subtitle, x-axis text, etc).
5. What level of raw count expression (low, medium, high) is the most frequent in the data? How is it possible?
6. Let's filter out the lowly expressed genes. A solid rule of thumb for RNA-seq data is to remove genes that have less than 10 reads in less than the minimum group size in the experiment. Remove all genes with less than 10 reads in less than 3 samples. There are a lot of ways to program this, be creative but keep it simple and elegant. How many genes did you removed, and how many are left?
