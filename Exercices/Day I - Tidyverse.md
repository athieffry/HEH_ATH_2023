## Tidyverse exercices

Using the `tidyverse` and `magrittr` pipes, explore the `diamonds` dataset (which comes with the tidyverse) to answer the following exercices:

1. Keep only the columns "cut", "color", and "price" for diamonds that are "Ideal" cut and have a price greater than 5000. How many diamonds are left?
2. Calculate the average price for each cut type and order the resulting tibble by decreasing average price. What is the cut and average price of the 3rd most expensive cut type?
3. Create a new column called "id", which should have values in the format "D_n", where n is the row number. You should use `mutate()`, `paste0()`, and `nrow()`. Finally, move the "id" column to the row names. What class is the diamonds data, now?
4. Goup the diamonds by "color", and then use `summarise()` to find the average "carat" size and the maximum "price" within each group. Use `pull()` to produce a vector of diamond "color" by increasing average carat. What is the vector class?
5. Create a summarized dataframe that would show the number of diamonds by cut and by color. Use `group_by()`, `summarize()`, and `n()`. What is the number of Good D diamonds?
6. Calculate the average price of diamonds by clarity and cut, and store that information in a new column called "average_price". Now pivot the data so that columns are "clarity", followed by the different cuts (fair, good, very good, etc.), and the values are the average price.
7. Using `unite()`, combine the "cut" and "color" columns into a single column named "cut_color", whose values are separated by "_".
8. Filter the `diamonds` dataset for diamonds with a "carat" greater than 0.3 and a "price" less than 1000. Then, group by "cut" and "color" and summarise to find the average "price" and the count of diamonds in each group. How many Good D diamonds are there, and what is their average price?
