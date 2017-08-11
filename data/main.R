# Preprocess data
source("data.R")

library(rmarkdown)
library(knitr)
render("overview.Rmd")
knit("overview.Rmd")