# func.R
# version 1.03 removed sql-related
# added divide_levels
# functions to be called in scripts
# author: Richard Careaga
# Date: 2022-02-28


# transform the levels variable from one long string 
# to a vector of single strings that can be applied
# to factors with the levels() function

divide_levels <- function(x) strsplit(the_levels[x],"; ")

# load raw data from saved data frame

get_intake <- function() readRDS(here("obj/intake.Rds"))

# what R type is this object?

get_type <-function(x) typeof(x[[1]])

# send most recently added column from last to first place

make_last_first <- function(x) x[,c(dim(x)[2],1:(dim(x)[2]-1))]

# convert "n/a" in descriptions of variables to NA

make_NA <- function(x) ifelse(x == "n/a",NA,x)

