# Walkthrough: https://ropenscilabs.github.io/drake-manual/intro.html
# Slides: https://krlmlr.github.io/drake-pitch
# Code: drake_example("main") # nolint
## https://krlmlr.github.io/slides/drake-sib-zurich/#28

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
  raw_data = readxl::read_excel(file_in(here("data", "raw_data.xlsx"))),
  data = raw_data %>%
    mutate(Species = forcats::fct_inorder(Species)) %>%
    select(-X__1),
  hist = create_plot(data),
  fit = lm(Sepal.Width ~ Petal.Width + Species, data),
  report = rmarkdown::render(
    knitr_in(here("report", "report.Rmd")),
    output_file = file_out(here("report", "report.html")),
    quiet = FALSE
  )
)

## check graph 
## -------------------------

config <- drake_config(plan)
# Warning message: knitr/rmarkdown report 'report.Rmd' does not exist and cannot be inspected for dependencies. 

vis_drake_graph(config)
# Error: The specified pathname is not a file: data

## Run your work with make().
## -------------------------

make(plan)
#fail report
#Error: Target `report` failed. Call `diagnose(report)` for details. Error message:
#  object 'fit' not found
#In addition: Warning messages:
#  1: missing input files:
#  raw_data.xlsx
#report.Rmd 
#2: Missing files for target report:
#  "report.html" 

## Now check again
## -------------------------
config <- drake_config(plan)
vis_drake_graph(config)

