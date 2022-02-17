# assignment.R
# Assign variables to appropriate type by prefix type
# author: Richard Careaga
# Date: 2022-02-14

# functions
get_type <-function(x) typeof(x[[1]])

# read in the entire file
intake <- readr::read_csv(here::here("data/2_DATA_Sample.csv"))

# examine column names
the_vars <- colnames(intake)
# put into a data frame numbered sequentially
the_index <- data.frame(index = 1:length(the_vars), var = the_vars)

cb <- readr::read_csv(here::here("doc/codebook.csv"))

# sui_flag
sui <- readRDS(here::here("obj/sui_flag.Rds"))
get_type(sui)
# inspect
head(sui)
# to be converted to factor
# SQL code to assign
# 
