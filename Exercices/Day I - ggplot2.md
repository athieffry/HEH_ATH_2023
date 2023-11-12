# ggplot2 exercises

Refresh your knowledge of **ggplot2** using the `diamonds` (part of Tidyverse):

1. Create a scatter plot to visualize the relationship between `carat` and `price` of diamonds.
2. Modify the above scatter plot by coloring the points based on the `cut` of the diamonds.
3. Create a scatter plot of `carat` vs `price`, but this time, facet the plot by the `cut` of the diamonds.
4. From the previous plot, add all relevant labels (title, X-axis, Y-axis).
5. Still building up from the previous plot,  apply a logarithmic transformation to the `price` axis.
6. Using geom_smooth, add a regression line to the scatter plots to show the trend. Also, make the plots square (use `aspect.ratio` in `theme()`).
7. Create a boxplot showing the distribution of `price` for each level of `clarity`. Color the boxes by level of clarity, be sure to use a gradient color (from `RColorBrewer` package) that goes from red (bad) to green (good). Tip: use `display.brewer.all()` to find the best color palette.
8. Generate a density plot of `carat`, faceted by `cut`. The plots should all be in one colum.
