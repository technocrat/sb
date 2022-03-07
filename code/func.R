# func.R
# version 1.03 removed sql-related
# added divide_levels
# functions to be called in scripts
# author: Richard Careaga
# Date: 2022-02-28

# transform the levels variable from one long string 
# to a vector of single strings that can be applied
# to factors with the levels() function as the labels 
# argument

# match variable names with their respective answer choices

ask_question <- function(x) var_level[which(var_level$levels == answers[x]),][[1]]

divide_levels <- function(x) strsplit(the_levels[x],"; ")

# assign type factor to variables that should be factors

factorise <- function(x) factor(intake[,ask_question(x)][[1]], labels = divide_levels(x)[[1]])

# because yanks can't spell

factorize <- factorise

# vector of variables that have a given cb$level (the answers, e.g.,
# "1. Yes; 2. No"

find_labels <- function(x) cb[which(cb$levels == x),1][[1]]

# load raw data from saved data frame

get_intake <- function() readRDS(here("obj/intake.Rds"))

# what R type is this object?

get_type <-function(x) typeof(x[[1]])

# send most recently added column from last to first place

make_last_first <- function(x) x[,c(dim(x)[2],1:(dim(x)[2]-1))]

# convert "n/a" in descriptions of variables to NA

make_NA <- function(x) ifelse(x == "n/a",NA,x)

# create a table of variables with corresponding answer choices

make_var_level <- function() {
  var_level = cb[,c(1,14)]
  a = var_level[!is.na(var_level$levels),]
  a[-grep("n/a",a$levels),]
}

# create the_labels object

pick_labels <- function(x) unique(the_levels)[x]

