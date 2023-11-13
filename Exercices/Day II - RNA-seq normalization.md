## RNA-seq normalization - exercises

You will find a gene expression matrix from an RNA-seq experiment investigation the transcriptome response of Arabidopsis thaliana (the plant model) to a flagellin treatment. The flagellin peptide simulates attack from a bacterial pathogen and should trigger a defense response from the plant. Your task is, first, to investigate the data and assess whether the experiment went well.

1. Use the `readxl` library to read the data in R. How many genes have been quantified? How many samples are provided and what is the number of replicates?
2. Assess the distribution of read counts between samples in order to see if there are obvious outliers. Using ggplot2, create a density plot showing the distribution for all samples, colored by condition (control vs treatment). You will need to transform the data in long format using `melt()` from the `reshape2` package. What do you observe in the density plot?
3. Building up from the previous plot, add a logarithmic scale for the X-axis. What is the warning message ggplot2 is showing you, and where does it come from?
4. Try to come up with a solution to solve the warning created from the previous plot. Also, provide the plot with a 0.5 figure ratio and all the appropriate labels (title, subtitle, x-axis text, etc).
5. What level of raw count expression is the most frequent in the data? How is it possible
