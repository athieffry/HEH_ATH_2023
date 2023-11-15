# ggplot2 exercices: Solutions
# Axel Thieffry - Nov. 2023library(tidyverse)
library(tidyverse)
library(RColorBrewer)
library(magrittr)

# Q1
ggplot(diamonds, aes(x=carat, y=price)) +
       geom_point()

# Q2
ggplot(diamonds, aes(x=carat, y=price, col=cut)) +
       geom_point()

# Q3
ggplot(diamonds, aes(x=carat, y=price)) +
       geom_point() +
       facet_grid(~cut)

# Q4
ggplot(diamonds, aes(x=carat, y=price)) +
       geom_point() +
       facet_grid(~cut) +
       labs(title='Diamonds', subtitle='Price vs carat per cut type',
            x='Carat', y='Price')

# Q5
ggplot(diamonds, aes(x=carat, y=price)) +
       geom_point() +
       facet_grid(~cut) +
       scale_y_log10() +
       labs(title='Diamonds', subtitle='Price vs carat per cut type',
            x='Carat', y='Price')


# Q6
ggplot(diamonds, aes(x=carat, y=price)) +
       geom_point() +
       geom_smooth() +
       facet_grid(~cut) +
       scale_y_log10() +
       theme(aspect.ratio=1) +
       labs(title='Diamonds', subtitle='Price vs carat per cut type',
            x='Carat', y='Price')

# Q7
install.packages('patchwork')
library(patchwork)
gg_7 <- ggplot(diamonds, aes(x=clarity, y=price, fill=clarity)) +
               geom_boxplot() +
               scale_fill_brewer(palette='RdYlGn')

# Q8
gg_8 <- ggplot(diamonds, aes(x=carat)) +
               geom_density() +
               facet_grid(cut~.)

gg_7 + gg_8
gg_7 / (gg_8 + gg_7)
