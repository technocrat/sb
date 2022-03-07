# factor_practice.R
# version 1.1: READY
# Assign variables to appropriate type
# use INTERACTIVELY ONLY; read comments
# the script does not save the results
# it's for practice only
# author: Richard Careaga
# Date: 2022-03-05

# libraries, functions

source("prepare.R")

# function for the first part of the script only

factorise <- function(x,y) {
  factor(intake[,x][y][[1]], labels = divide_levels(1)[[1]], ordered = TRUE)
}

# codebook data frame was created by fdict.R and saved as .Rds

cb <- readRDS(here("obj/fdict.Rds"))

# survey data frame created by convert_xl.R and saved as .Rds
# this imports the 9-row sample version; to use the complete 
# data, use the convert_xl.R script to convert and save the 
# actual data to the intake.Rds file AFTER doing the exercise

intake <- get_intake()

# get variable types

var_types <- sapply(intake,typeof)
var_types
length(var_types) # 318 variables
var_char <- grep("character",var_types, value = TRUE)
var_logic <- grep("logical",var_types, value = TRUE)

# all accounted for;; none are numeric types

length(var_char) + length(var_logic)

# identify "intro"

length(grep("intro",names(var_logic)))

# remove them

intake <- intake[,-grep("intro",colnames(intake))]

# find variables to be converted to numeric

numerics <- cb[which(cb$vartype == "Numerical"),][,c(1,6)][[1]]
numerics

# convert them

intake[,numerics] <- sapply(intake[numerics],as.integer)

# find the variables to be converted to factor

# 39 unique answer sets (levels)
the_levels <- unique(cb$levels)
length(the_levels)

# inspect

# "n/a" and NA are present, because all 318 rows have
# an entry for level but not all of those rows
# represent variables to be classified as factors

the_levels[c(1,9)]
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

# dem_consent cannot be a factor with "1. Yes; 2. No" unless at least
# ONE occurrence of 2 is present; that is, the number of unique recorded
# values must equal the number of levels
# example: dem_consent--this WILL produce an error


factorise(the_yes_no,1)

# for this variable, we can assign type logical, which permits all TRUE,
# all FALSE or a combination of TRUE and FALSE; we can still confirm
# that all rows have answered "1"  by simply checking with mean(dem_consent)
# the result will be 1 if all rows have TRUE, and if the result is less than
# 1, then some rows have FALSE, and if no answer is recorded, mean return NA
# and those rows will have to be removed or kept anyway

# Because we expect ALL to be TRUE, we can use type logical, which avoids
# the issue with using type factor

intake$dem_consent <- as.logical(as.integer(intake$dem_consent))

# the si variable has this issue as well in my 9-row sample data, because
# all entries are recorded as "1," so I have manually (gasp!) changed the
# data to allow the code to work, as it seems likely that in the real
# data some entries are recorded as "2" I made the first record into a "2
# intake$s1[1] <- "2" Please never make a manual adjustment to a data frame;
# go back to the source document, save it and create a copy and make the
# adjustment there, then reimport and rerun the script.

intake$si[2] <- "2"

factorise(the_yes_no,2)
intake$si <- factorise(the_yes_no,2)

# the others are fine without adjustment into type logical or by
# manual adjustment

intake[,the_yes_no[c(2,3,5)]]

intake$dem_kids <- factorize(the_yes_no,2)
intake$pain_talk <- factorize(the_yes_no,2)
intake$sa <- factorize(the_yes_no,2)

# check that the_yes_no variables are now all factors

str(intake[the_yes_no])

# reload function library to use a revised factorise() function

source(here("data/func.R"))

# remove "intro/obsolete" from codebook

cb <- cb[-which(cb$vartype == (obsintro <- cb$vartype |> unique())[4]),]

var_level <- make_var_level()

answers <- unique(var_level$levels)

# starting with 2, because 1--the Yes/No variables
# "dem_consent" "dem_kids"    "pain_talk"   "si"          "sa"
# already done above

factorise(2)

# this throws an error, because all the values are 1, but there are 
# 4 levels to be assigned, so this requires another manual fix to the 
# sample data frame, intake

intake$dem_gender <- c("1","2","3","4","1","2","3","4","1")

factorise(2)

# this won't work because, like dem_gender, the sample data for
# "dem_ethnicity" don't have enough distinct values to cover t
# the required levels--only 1. White and 5. Mixed / Multiple
# ethnicities present

# this works, but factors aren't appropriate; since we only
# have descriptions for 0. No affect and 10. Severely affects
# (btw, it should have been No "e"ffect)

factorise(13)

# this works because the emot_depress_X variables have enough
# diffrent values to cover the factor levels

factorise(18)

# end of of practice