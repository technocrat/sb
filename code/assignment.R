# assignment.R
# Version 0.5 NOT READY
# Assign variables to appropriate type 
# Version 1.0.1 use SQL output of fdict.R
# author: Richard Careaga
# Date: 2022-02-17
# TODO conform to fdict.R

# libraries

source(here("code/libr.R"))

# functions

source(here::here("code/func.R"))

# data

# codebook data table created by fdict.R

con <- r_open_sql("polytrope")
cb <- dbReadTable(con, "codebook")

# read in the entire file raw data excel sheet

intake <- get_intake()

# create a variable for classification as a factor, initially all FALSE

cb$factor <- FALSE

cb$factor[which(str_detect(cb$vartype,"Factor"))] <- TRUE

# identify  and remove "intro/obsolete" variables from codebook
# misspelling of obsolete is in the original

cb <- cb[-which(str_detect(cb$vartype,"Obselete")),]


# find variables to be made into numerical type

numericals <- cb[which(cb$vartype == "Numerical"),]

