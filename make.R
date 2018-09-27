# Walkthrough: https://ropenscilabs.github.io/drake-manual/intro.html
# Slides: https://krlmlr.github.io/drake-pitch
# Code: drake_example("main") # nolint
## https://krlmlr.github.io/slides/drake-sib-zurich/#28

## look at the folder structure:
cat(
  system(
    "tree ../test_drake",
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

file.exists(here::here("data", "raw_data.xlsx"))
## [1] TRUE
file.exists(here::here("report", "report.Rmd"))
## [1] TRUE
#fs::link_create(here::here("report", "report.Rmd"), "report.Rmd")

fs::link_create(here::here("data", "raw_data.xlsx"), "raw_data.xlsx")
system(glue::glue("cp report/report.Rmd report.Rmd"))

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



