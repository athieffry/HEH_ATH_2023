# RNA-seq normalization exercises: Solutions
# Axel Thieffry - Nov. 2023
library(tidyverse)
library(tidylog)
library(magrittr)
library(readxl)
library(reshape2)
library(patchwork)
library(ggrepel)
'%!in%' <- Negate('%in%')
'h' <- head
'at' <- as_tibble
'l' <- length

PLOT <- FALSE


# 1. Read expression matrix
# -------------------------
mat <- read_xlsx('~/Dropbox/Documents/HEH - Guest Lecturing/HEH_ATH_2023/datasets/gene_count_matrix.xlsx')
dim(mat)


# 2. Gene expression density plot per sample, colored by condition
# ----------------------------------------------------------------
mat_long <- mat %>%
            melt(id.vars='gene_id', variable.name='sample', value.name='count') %>%
            mutate('condition'=str_remove(sample, '_R.*$'))

if(PLOT) {
          ggplot(mat_long, aes(x=count, col=condition, groups=sample)) +
                 geom_density()

          ggplot(mat_long, aes(x=count, colour=condition, groups=sample)) +
                 geom_density() +
                 scale_x_log10()

          ggplot(mat_long, aes(x=count+1, col=condition, groups=sample)) +
                geom_density() +
                scale_x_log10() +
                theme(aspect.ratio=1) +
                labs(title='Gene counts distribution',
                     subtitle='pseudocount: 1',
                     x='count (log-scaled, pseudocount=1)')
          }


# 3. Removing lowly expressed genes (based on readcount)
# ------------------------------------------------------
genes_tokeep <- mat %>%
                melt(id.vars='gene_id', variable.name='sample', value.name='counts') %>%
                mutate('pass'=counts >= 10) %>%
                separate('sample', c('condition', 'rep'), '_') %>%
                group_by(gene_id, condition) %>%
                summarize('sumpass'=sum(pass)) %>%
                filter(sumpass == 3) %>%
                ungroup() %>%
                pull('gene_id') %>%
                unique()

mat_filtered <- mat %>% filter(gene_id %in% genes_tokeep)

mat_filtered_long <- mat_filtered %>%
                     melt(id.vars='gene_id', variable.name='sample', value.name='count') %>%
                     mutate('condition'=str_remove(sample, '_R.*$'))


# 4. RPM normalization
# --------------------
# get total number of reads from ALL genes (so use the initial matrix)
total_reads <- mat %>% select(-gene_id) %>% colSums()

rpm_filtered <- mat_filtered %>%
                column_to_rownames('gene_id') %>%
                apply(1, \(x) divide_by(x, total_reads/1e6)) %>%
                t() %>%
                as.data.frame()

# sanity check - total of columns should be close to 1M
colSums(rpm_filtered)


# 5. Compare distributions
# ------------------------
if(PLOT) {
          gg_a <- mat_filtered %>%
                  melt(id.vars='gene_id', variable.name='sample', value.name='count') %>%
                  mutate('condition'=str_remove(sample, '_R.*$')) %>%
                  ggplot(aes(x=count+1, col=condition, groups=sample)) +
                         geom_density() +
                         scale_x_log10() +
                         theme(aspect.ratio=.5) +
                         labs(title='Counts distribution', subtitle='filtered data', x='log(count+1)')

          gg_b <- rpm_filtered %>%
                  rownames_to_column('gene_id') %>%
                  melt(id.vars='gene_id', variable.name='sample', value.name='rpm') %>%
                  mutate('condition'=str_remove(sample, '_R.*$')) %>%
                  ggplot(aes(x=rpm+1, col=condition, groups=sample)) +
                         geom_density() +
                         scale_x_log10() +
                         theme(aspect.ratio=.5) +
                         labs(title='RPM distribution', subtitle='filtered data', x='log(count+1)')

          gg_a / gg_b
          }


# 6. Read gene annotation BED file
# --------------------------------
# a. read file and give column  names
genes_bed <- read.table('~/Dropbox/Documents/HEH - Guest Lecturing/HEH_ATH_2023/datasets/Arabidopsis_thaliana_TAIR10_genes.bed') %>%
             set_colnames(c('chr', 'start', 'end', 'gene_id', 'score', 'strand')) %>%
             as_tibble()

# b. check that number of lines is same as number of genes (no duplication)
n_distinct(genes_bed$gene_id) == nrow(genes_bed)

# c. calculate and add gene length in new column
genes_bed %<>% mutate('length'=end-start)
      # which is same as
      # genes_bed <- genes_bed %>% mutate('length'=end-start)
      # which is same as
      # genes_bed <- mutate(genes_bed, 'length'=end-start)

# d. plot gene length distribution (density)
ggplot(genes_bed, aes(x=length)) +
       geom_density() +
       scale_x_log10() +
       labs(title='Gene length distribution',
            x='Gene length (bp, log-scaled)')

mean(genes_bed$length)
summary(genes_bed$length)

# e. how many genes in our RPM matrix are found in the BED annotation?
table(rownames(rpm_filtered) %in% genes_bed$gene_id)

genes_bed %<>% filter(gene_id %in% rownames(rpm_filtered))
rpm_filtered %<>% subset(rownames(rpm_filtered) %in% genes_bed$gene_id)

# check
nrow(genes_bed)==nrow(rpm_filtered)

# f. reorder the BED file to have only the matrix genes and in the same order
reorder_idx <- match(rownames(rpm_filtered), genes_bed$gene_id)
genes_bed <- genes_bed[reorder_idx, ]
# sanity check - do gene IDs all match?
all(genes_bed$gene_id == rownames(rpm_filtered))

# g. divide gene lengths by 1000 to get the "K" in RPKM
genes_bed %<>% mutate('length_kb'=length/1000)

# h. normalize to RPKM
rpkm <- rpm_filtered %>%
        apply(2, function(x) divide_by(x, genes_bed$length_kb)) %>%
        as.data.frame()

# i. check relationship between expression and gene length

# check that relationship bias between length and expression is less strong
gg_rpm <- rpm_filtered %>%
          as.data.frame() %>%
          rownames_to_column('gene_id') %>%
          left_join(genes_bed, by='gene_id') %>%
          ggplot(aes(x=ctrl_R1+1, y=length_kb)) +
                 geom_point(alpha=.1) +
                 scale_x_log10() + scale_y_log10() +
                 geom_smooth(method='lm') +
                 theme(aspect.ratio=.75)

gg_rpkm <- rpkm %>%
           as.data.frame() %>%
           rownames_to_column('gene_id') %>%
           left_join(genes_bed, by='gene_id') %>%
           ggplot(aes(x=ctrl_R1+1, y=length_kb)) +
                  geom_point(alpha=.1) +
                  scale_x_log10() + scale_y_log10() +
                  geom_smooth(method='lm', se=T) +
                  theme(aspect.ratio=.75)

gg_rpm / gg_rpkm

# check that overall expression distribution has been lowered (less biased by long genes)
gg_before <- ggplot(rpm_filtered, aes(x=ctrl_R1+1)) + geom_density() + scale_x_log10() + labs(title='RPM')
gg_after <- ggplot(rpkm, aes(x=ctrl_R1+1)) + geom_density() + scale_x_log10() + labs(title='RPKM')
gg_before/gg_after

# j. create a correlation matrix from the data
cor(rpkm)

# k. create a correlation heatmap with corrplot (package to install)
corrplot(corr=cor(rpkm), is.corr=F, diag=F, order='hclust', addrect=2)

# l. save total mapped reads
saveRDS(total_reads, '~/Dropbox/Documents/HEH - Guest Lecturing/HEH_ATH_2023/datasets/total_reads.rds')
# m. save filtered count matrix
saveRDS(mat_filtered, '~/Dropbox/Documents/HEH - Guest Lecturing/HEH_ATH_2023/datasets/mat_filtered.rds')
