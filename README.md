<img width="1430" alt="Screenshot 2022-10-25 at 10 46 07" src="https://user-images.githubusercontent.com/6929960/197727905-6b953946-1ac5-44f8-a780-ff99e974e276.png">

Materials for the *Complement of Bioinformatic Technics II* course, [Master in Life Data Technologies](https://www.heh.be/master-ingenieur-en-technologies-des-donnees-du-vivant "link to Master program course list").
Faculty of Sciences & Technologies, Haute-Ecole en Hainaut ([HEH](https://www.heh.be "link to HEH official webpage")) - November 2023

## Requirements

- A fresh R installation (**v4.3.2** or above): [https://www.r-project.org](https://www.r-project.org "link to download R")
- RStudio (**2023.09.1+494** or above): [https://posit.co/downloads/](https://posit.co/downloads/ "link to download RStudio")
- The following R packages:

  ```bash
  # run this in RStudio
  install.packages("tidyverse")
  install.packages("tidylog")
  install.packages("magrittr")
  install.packages("reshape2")
  install.packages("patchwork")
  install.packages("BiocManager")
  ```
- The following Bioconductor packages:

  ```bash
  # run this in RStudio
  BiocManager::install("GenomicRanges")
  BiocManager::install("GenomicFeatures")
  BiocManager::install("rtracklayer")
  ```

*Note:* you can check that installations were successful by loading each package using the command `library('package_name')`.

## Useful things

##### FiraCode

FiraCode is a great font that simplifies reading of scripts. Visit their [GitHub page](https://github.com/tonsky/FiraCode "FiraCode GitHub page") to see it by yourself and install it!

##### RStudio parameters

Visit the RStudio options and check the following settings:

- General > Workspace > Restore .RData ... (uncheck)
- General > Workspace > Save workspace to .RData ... > Never
- General > History > Always save history (uncheck)
- Code > Display > Syntax > Highlight R function calls (check)
- Code > Display > Syntax > Use rainbow parentheses (check)
- Code > Display > Completion > Insert spaces around equals ... (uncheck)
- Code > R Diagnostics > Prompt to install missing R packages ... (check)
- Appearance > Chose the theme you like! (Recommended: Cobalt)
- Appearance > Editor Font > FiraCode (see above for installation)

Feel free to explore other parameters and see what works best for you.
