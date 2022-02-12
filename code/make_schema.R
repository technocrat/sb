# make_schema.R
# Convert question column names and types to SQL names and types
# revision 0: starting with character comments only
# author: Richard Careaga
# Date: 2022-02-11

# install("readr")
# install("here")
# open RStudio and
getwd()
# save your data from excel as a csv file in that directory
# and substitute the name of the csv file
# for data/2_DATA_Sample.csv in line 17
# read in the entire data
#==============================================================
#                         EDIT ME
intake <- readr::read_csv(here::here("data/2_DATA_Sample.csv"))
# see lines 6-12 above
#==============================================================

# Motivation: R and MySQL have comparable ways of describing
# variables (called columns in R data frames and fields in SQL)
# To set up the MySQL table to hold the data we have to translate
# the syntax from R to SQL.
# The purpose of this script is to do that automatically because
# there are 318 columns, which is too many to do by hand without
# risk of hair loss

# inventory column types

# explanation apply the typeof function to the data frame's variables
# to find their types
var_types <- sapply(intake,typeof)

unique(var_types)

# there are three types

# these have corresponding types in SQL
# character is varchar
# double can be float, double, decimal or numeric
# logical is tricky

# varchar has to specify a size in number of characters
# big enough to take in the longest entry and to keep
# the total of all character variables under the magic
# number cap of 65,535 bytes (2^16 - 1)

# isolate the character variables

# this is this is {base} subsetting using the [] operator
# in tidyverse {dplyr} this would be
# char_var <- intake %>% select(where(is.character))
# so, which is preferable?
# a lot depends on cognitive orientation which makes
# it solely a matter of personal choice
# so here's my interior dialog on the tidy
# ok, I've got a data frame, so I guess I should
# send (pipe %>%) it to something, ok select
# select what? If I knew already I wouldn't even
# have to do this, just select(col1,col3,col6),
# so how to I tell it to select just the chacracter
# variables? Wait, I remember, there's another
# verb, let's read the documentation ... read to 
# the end of the top part of the description and
# ah, ha, there it is "You can also use predicate
# functions like is.numeric, but I'm looking for
# character, not numeric, so maybe is.character?
# intake %>% select(is.character)
# no that's wrong, the error message tells me
# that it needs to be data %>% select(where(is.character))
# This is a procedural style--do this, then do that
# so here's the thought process on the alternative
# in base
# I have a data frame with three different types
# of variable. I know this because unique(var_types)
# above. I want a all rows from that data frame
# that have character variables (only, no double
# or logical), so I can subset
# intake[,.. means all rows and to specify 
# columns, I can use var_types to tell me by asking
# ...which(var_types == "character")], remembering that
# the damn = sign doesn't mean equal, it means
# "make equal to"; I want == 
# and since I want to do things to this, I'll save
# it with <- (I could use =, but that's frowned on)
char_var <- intake[,which(var_types == "character")]

# find the maximum number of characters required
# With the new data frame in hand, I know want
# to know what the largest number of characters
# is in any row/col entry; because some values
# are missing, and coded NA, I have to exclude
# them explicitly because you can't do arithmetic
# on objects containing NA
max(sapply(char_var,nchar),na.rm = TRUE)
# find the mean number of characters required
mean(sapply(char_var,nchar),na.rm = TRUE)
# if we use max for everything, are we within the magic number?
# dim() is just a vector (one or more numbers) with the number of rows
# first and the number of columns second, 9 rows and 25 columns 
dim(char_var)
# just columns
dim(char_var)[2]
# c(2^16-1) creates the one number vector 65535, but 2^16-1 does also
# so why use the c() form?
# because of precedence, in a couple of lines we'll be using this again
# where we don't get the same result
# this works
mean(sapply(char_var,nchar),na.rm = TRUE) * dim(char_var)[2] < c(2^16-1)
# this doesn't
2^16-1 / dim(char_var)[2]
# we could also use a temporary variable
magic <- 2^16-1
magic
# magic is evaluated before any pesky / but now we've got another
# object in namespace to worry about, besides the perenial problem
# of coming up with a name, so these convenience variables can become
# inconvenient
# where'd the 0.96 come from?
# precedence: division is done before subtraction so this is the same
# as 2^16 - 1/25 (useful factoid 1/50 is 2%, so 2/50, which is 1/25
# is twice that, 4%)
# to what can we increase the value?
c(2^16-1) / dim(char_var)[2]
# a bit over 2600, but for efficiency, let's find the largest
# power of two less than that--computers like powers of two
# we're only interested in powers of two less than the magic number,
# which is just smaller than 2^16, so let's check

2^max(which(c(2^(1:15)) < c(2^16-1) / dim(char_var)[2]))

# ok, this looks ugly but bear with me: it's just analysis!
# unfortunately analysis is so painful that it drives
# people crazy; law students spend their first year trying
# to avoid breaking things down to their component parts
# and spend insane hours doing everything but
# but it's easy we've got objects we already know about
# (everything is an object, including functions and operators)
# thinking in terms of what
# 1. we have the number of columns in char_var, from dim(char_var)[2])
# 2. we are looking for a power of the number 2 2^something
# 3. specifically, we want the biggest (max) on that is less than
# the magic number 2^16-1 (here as c(2^16-1), wrapped in c() to
# avoid the upcoming /)
# Using brute force, we look at all of the powers of 2 that are less thaa
# 16, represented by the sequence 1:15 that we use as exponents of 2
c(2^1:15)
# to produce a vector and compare each of its element to 2^16, using
# the < operator for a logical test and they all pass
c(2^(1:15)) < c(2^16-1)
# how do pick the one we want?
# it is the last TRUE power and which() tells us the positions
# of the powers, arranged in ascending powers of two
which(c(2^(1:15)) < c(2^16-1) / dim(char_var)[2])
# so we find the max of that list of indices
max(which(c(2^(1:15)) < c(2^16-1) / dim(char_var)[2]))
# which is 11, so we use that as the exponent for 2
2^11
# now we know that we can allocate storage in SQL
# of 2048 bytes per column which 
# 1. is big enough for the biggest entry, which we found
# out above is
max(sapply(char_var,nchar),na.rm = TRUE)
# 2. doesn't overrun the budget when added together
# because 2048 
2^11
# times 25
dim(char_var)[2]
# is
2^11*dim(char_var)[2]
# and that is less than 65535
2^11*dim(char_var)[2] < 2^16

# by now, you are either
# 1. beginning to feel a glimmer of enlightenment or
# 2. wondering why I just don't do the math directly
2048*25
# and the reasons are
# 1. I'm mildly numerically dyslexic and I might write
2084*25
# which is only off a little but like always buckling
# my seat belt EVERY time, I never forget
# 2. When I get distracted or tired or stressed, I
# tend toward mistakes of this nature that can
# burrow deeply and be hard to find
20480*25
# so my mantra is "get as close as possible to the
# data and don't let your clumsy brain do anything
# with it unreliably that the computer can be
# trusted to do perfectly if you ask nicely"