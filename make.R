## Drake example that uses a simple folder structure 
## and copies files in folder to "root" 
## ------------

## look at the folder structure:
cat(
  system(
    "tree ../drake-example",
    intern = TRUE),
  sep = "\n"
)

## if needed, clean all drake cache
## drake::clean(destroy = TRUE)

library(drake)
library(tidyverse)
library(here)
pkgconfig::set_config("drake::strings_in_dots" = "literals") # New file API

## check supporting files
## -------------------------

system("cp report/report.Rmd report.Rmd")
system("cp data/raw_data.xlsx raw_data.xlsx")

file.exists(here("data", "raw_data.xlsx"))
## [1] TRUE
file.exists(here("report", "report.Rmd"))
## [1] TRUE

# Your custom code is a bunch of functions.
## -------------------------

source(here("R", "functions.R"))

# The workflow plan data frame outlines what you are going to do.
## -------------------------

plan <- drake_plan(
  raw_data = readxl::read_excel(file_in("raw_data.xlsx")),
  data = raw_data %>%
    mutate(Species = forcats::fct_inorder(Species)) %>%
    select(-X__1),
  hist = create_plot(data),
  fit = lm(Sepal.Width ~ Petal.Width + Species, data),
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = FALSE
  )
)

## check graph 
## -------------------------

config <- drake_config(plan)
vis_drake_graph(config)

## Run your work with make().
## -------------------------

make(plan)

## Now check again
## -------------------------
config <- drake_config(plan)
vis_drake_graph(config)

## remove files again
## --------------------
system("rm report.Rmd")
system("rm raw_data.xlsx")

