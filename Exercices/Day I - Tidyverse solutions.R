# Tidyverse exercices: Solutions
# Axel Thieffry - Nov. 2023
library(tidyverse)
library(magrittr)

# Q1 - 4,985
diamonds %>%
  select(cut, color, price) %>%
  filter(cut=="Ideal", price > 5000)

# Q2 - Very good: 3982
diamonds %>%
  group_by(cut) %>%
  summarise('average_price'=mean(price)) %>%
  arrange(desc(average_price))

# Q3 -
diamonds %>%
  mutate('id'=paste0('D_', 1:nrow(diamonds))) %>%
  column_to_rownames('id')

# Q4
diamonds %>%
  group_by(color) %>%
  summarise('average_carat'=mean(carat),
            'max_price'=max(price)) %>%
  arrange(desc(average_carat)) %>%
  pull(color)

# Q5
diamonds %>%
  group_by(cut, color) %>%
  summarise('count'=n()) %>%
  ungroup()

# Q6
diamonds %>%
  group_by(cut, clarity) %>%
  summarise('average_price'=mean(price), .groups='drop') %>%
  pivot_wider(names_from='cut', values_from='average_price')

# Q7
diamonds %>%
  unite('cut_color', c('cut', 'color'), sep='_')

# Q8
diamonds %>%
  filter(carat > 0.3, price < 1000) %>%
  group_by(cut, color) %>%
  summarise('average_price'=mean(price),
            'count'=n())


thanos_snap <- function(df) {
                            message('Killing 50% of your df.')
                            df %<>% sample_n(round(nrow(df))/2)
                            return(df)
                            }

diamonds2 <- thanos_snap(diamonds)
dim(diamonds)
dim(diamonds2)

# RColorBrewer
library(RColorBrewer)

display.brewer.all()
display.brewer.pal(name='Dark2', n=3)

c(brewer.pal(name='Dark2', n=3),
  brewer.pal(name='Set2', n=3))

