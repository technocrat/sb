# assignment.R
# version 1: 
# Assign variables to appropriate type
# use INTERACTIVELY ONLY
# author: Richard Careaga
# Date: 2022-02-28

# libraries, functions and open sql

source("prepare.R")

# codebook data frame created by fdict.R

cb <- readRDS(here("obj/fdict.Rds"))

# survey data frame created by convert_xl.R

intake <- get_intake()

# get variable types

var_types <- sapply(intake,typeof)
var_types
length(var_types) # 318 variables
var_char <- grep("character",var_types, value = TRUE)
var_logic <- grep("logical",var_types, value = TRUE)

# all accounted for;; none are numeric types

length(var_char) + length(var_logic)

# intake[names(var_logic)] |> t()

# identify "intro"

length(grep("intro",names(var_logic)))

# remove them

intake[grep("intro",colnames(intake),invert = TRUE,value = TRUE),]

# find variables to be converted to numeric

numerics <- cb[which(cb$vartype == "Numerical"),][,c(1,6)][[1]]

# convert them

intake[,numerics] <- sapply(intake[numerics],as.integer)

# find the variables to be converted to factor

# # dem_covid_impact variable is classified in intake as logical, because all
# are NA in the sample data, and it should be converted to character

intake[27] <- as.character(intake[27])

# 39 unique answer sets (levels)
the_levels <- unique(cb$levels)
length(the_levels)

# divide into three groups of 13 for convenience

levels_A <- the_levels[1:13]
levels_B <- the_levels[14:26]
levels_C <- the_levels[27:39]

# inspect

# "n/a" and NA are present, because all 318 rows have
# an entry for level but not all of those rows
# represent variables to be classified as factors

levels_A[c(1,9)]
cb[,c(1,14)]

# remove them

the_levels <- the_levels[-c(1,9)]

# all unique

length(unique(the_levels)) == length(the_levels)

# find questions with "1. Yes; 2. No" levels

# number to find

length(grep("1. Yes; 2. No",cb$levels,value = TRUE))

# inspect

cb[which(cb$levels == "1. Yes; 2. No"),c(1,3)]

# pain_talk appears incorrect, but looking 
# at the full question, it is not

cb[which(cb$variable == "pain_talk"),] |> t()

# vector of variables that have "1. Yes; 2. No" levels

the_yes_no <- cb[which(cb$levels == "1. Yes; 2. No"),1][[1]]

# used for the_yes_no variables only

factorise <- function(x) {
  factor(intake[,the_yes_no][x][[1]], labels = divide_levels(1)[[1]], ordered = TRUE)
}

# because yanks can't spell
factorize <- factorise

# dem_consent cannot be a factor with "1. Yes; 2. No" unless at least
# ONE occurrence of 2 is present; that is, the number of unique recorded
# values must equal the number of levels
# example: dem_consent

factorise(1)

# for this variable, we can assign type logical, which permits all TRUE,
# all FALSE or a combination of TRUE and FALSE; we can still confirm
# that all rows have answered "1"  by simply checking with mean(dem_consent)
# the result will be 1 if all rows have TRUE, and if the result is less than
# 1, then some rows have FALSE, and if no answer is recorded, mean return NA
# and those rows will have to be removed or kept anyway

intake$dem_consent <- as.logical(as.integer(intake$dem_consent))

# the si variable has this issue as well in my 9-row sample data, because
# all entries are recorded as "1," so I have manually (gasp!) changed the
# data to allow the code to work, as it seems likely that in the real
# data some entries are recorded as "2" I made the first record into a "2
# intake$s1[1] <- "2" Please never make a manual adjustment to a data frame;
# go back to the source document, save it and create a copy and make the
# adjustment there, then reimport and rerun the script.

intake$si <- factorise(2)

# the others are fine without adjustment either into type logical or by
# manual adjustment

intake[,the_yes_no[c(2,3,5)]]

intake$dem_kids <- factorize(2)
intake$pain_talk <- factorize(2)
intake$sa <- factorize(2)

# check that the_yes_no variables are now all factors

str(intake[the_yes_no])

################################################################################
# TODO: remaining factor variables, which now fall into 36 patterns to be
# matched with the corresponding variables and treated similarly to the_yes_no
################################################################################
