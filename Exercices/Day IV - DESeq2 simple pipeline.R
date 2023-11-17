library(tidyverse)
library(tidylog)
library(magrittr)
library(DESeq2)



# 1. READ DATA
total_counts <- readRDS('~/Dropbox/Documents/HEH - Guest Lecturing/HEH_ATH_2023/datasets/total_reads.rds')
mat_filtered <- readRDS('~/Dropbox/Documents/HEH - Guest Lecturing/HEH_ATH_2023/datasets/mat_filtered.rds') %>%
                column_to_rownames('gene_id')

# make sure all counts are integers
# (data had small problem, never do that in real life)
mat_filtered %<>% round()

# 2. CREATE DESIGN TABLE (colData)
colData <- tibble('sample'=colnames(mat_filtered),
                  'condition'=rep(c('control', 'treatment'), each=3))
# make sure that control is the base level (denominator)
colData %<>% mutate('condition'=factor(condition, levels=c('control', 'treatment')))

# check
levels(colData$condition)

# 3. CREATE DESEQ2 OBJECT THAT COMBINES ALL
dds <- DESeqDataSetFromMatrix(countData=mat_filtered,
                              colData=colData,
                              design= ~ condition)

# 4. PERFORM DIFFERENTIAL EXPRESSION ANALYSIS
dds <- DESeq(dds)

# 5. GET RESULTS
res <- results(dds) %>% as.data.frame()
head(res)

# 6. VOLCANO PLOT
res %<>% rownames_to_column('gene_id') %>% as_tibble()

res %>% ggplot(aes(x=log2FoldChange, y=-log10(padj), col=log2FoldChange>0)) +
               geom_point() +
               geom_hline(yintercept=-log10(0.05))


# 7. Gene Ontology enrichment
# up-regulated genes
up_degs <- res %>%
           filter(log2FoldChange >= 1, padj <= .05) %>%
           pull(gene_id)

length(up_degs)

install.packages('gprofiler2')
library(gprofiler2)
go <- gost(up_degs, organism='athaliana', significant=T, user_threshold=0.05, correction_method='fdr')

go$result %>% select(p_value, query_size, term_size, intersection_size, term_id, term_name) %>% as_tibble() %>% arrange(p_value)
