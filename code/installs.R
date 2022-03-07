# installs.R
# libraries to be installed
# Version 1.4 # add tidytext, stringr and wrapr and remove SQL-related 
# RMariaDB READY
# author: Richard Careaga
# Date: 2022-03-05

# initial libraries

add_library <- function(x) install.packages(x)

initial_libraries <- c("dplyr","ggplot2","here","lubridate","patchwork","readr","readtext","readxl","vcd")

add_library(initial_libraries)

# dplyr: tidyverse syntax for data frames
# ggplot2: tidyverse plotting
# here: allows referring to an object relative to current working directory
# lubridate: working with dates
# patchwork: multiple side by side and top bottom plots
# readr: import data
# readtext: reading Word document text
# readxl: reading Excel
# vcd: categorical analysis
# vcdExtra: additional functions

# second batch

second_batch <- c("docxtractr","stringr","tidytext",
                "wrapr")

add_library(initial_batch)
# docxtractr: extract tables from docx format
# stringr: find and replace using search patterns
# tidytext: extract free text from docx format
# wrapr: sort data frames by column