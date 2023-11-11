## ggplot2 exercices

##### Background

You've been given a matrix of genes counts from an RNA-seq experiment. The experiment investigated *Arabidopsis thaliana* seedlings before and after treatment (30 min) with the flg22 peptide, which simulates a bacterial pathogen attack. Your professor asks you a couple of questions with that experiment and often expects you to produce figures to support your answers.

##### Questions

1. Download the data from https://github.com/athieffry/HEH_ATH_2023/blob/main/datasets/gene_count_matrix.xlsx and read them into R using the `readxl` package. Store the matrix in a variable called "mat".
   - What are the dimensions of the gene count matrix?
   - How many biological replicates are found?
2. In one figure, show the distribution of gene counts for each sample, where the color of the line shows the condition. You will first neeed to use `melt()` from the `reshape2` package to transform the matrix into a long format. Then, you might want to use `separate()` to split the sample names into two colums: one for the condition, one for the replicate. If your plot looks weird, try to think about the axis scales...
