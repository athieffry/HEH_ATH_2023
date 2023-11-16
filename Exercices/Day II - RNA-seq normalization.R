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

