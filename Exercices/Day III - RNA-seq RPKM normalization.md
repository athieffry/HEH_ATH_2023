## RNA-seq RPKM - exercises

Download the Arabidopsis thaliana TAIR10 genome annotation in BED format found in the dataset folder.

1. In one step, read the file in R and give the dataframe (or tibble) the appropriate column names (chr, start, end, gene_id, score, strand).
2. Check the number of gene annotations and verify that there are no duplicated genes.
3. Create a new column named "size" that contains the length of genes, which you can calculate given the end and start.
4. Check how many genes from our RPM normalized matrix are found in the BED annotation.
