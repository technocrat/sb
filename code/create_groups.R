# create_groups.R
# Version 1.0 MAY NOT BE NECESSARY
# create separate data frame for each grouping of variables
# motivation: allow easier examination of each group while
# retaining the ability to cross reference to other groups
# author: Richard Careaga
# Date: 2022-02-08

# practice tip: when opening a new script start a new session 
# CTRL SHIFT F10 in RStudio
# to clear out namespace, unless there's good reason not to

# libraries

source(here::here("code/libr.R"))
# read in the entire file
intake <- read_xlsx(here::here("data/2_DATA_Sample.xlsx"))

# examine column names
the_vars <- colnames(intake)
# put into a data frame numbered sequentially
the_index <- data.frame(index = 1:length(the_vars), var = the_vars)
# divide by prefix
# this could be done programmatically and should if it's anticipated
# to be a recurring task, but it's manageable simply to eyeball the
# index positions (corresponding to columns of intake)

# select only variables beginning dem_, 

# expression for "starts with dem_"
# explanation: define how desired variables begin
# then subset based on that
# read as "create a new data frame named dem that
# takes from the data frame intake each row and
# the columns that begin with the specified target"
target <- "^dem_"
dem <- intake[,which(str_detect(the_index$var,target))]
dem

# that worked well, so let's make a function
# motivation: cuts down on cutting and pasting errors
make_var_frames <- function(x) intake[,which(str_detect(the_index$var,x))]

# note on naming things: it's harder than one would think
# there's a balance between descriptiveness and brevity
# my general practice is to have functions named after
# verbs and other objects, containing data, after nouns
# I use the the_ construct when I'm dealing with pieces
# that will be used to isolate some characteristics
# of a data object

# select only variables beginning child_,
child <- make_var_frames("^child_")
child

# so far we've dealt with the first 103 variables of 318
# how do we know?
dim(dem)[2] + dim(child)[2]
# translation, find the dimensions of the two data frame,
# row/column, then take the second of each (number of columns
# equals number of variables) and add together
# it would be possible to automate this further by extracting
# all the ^start_ patterns from the_vars, but we'll wait to
# apply that pattern until later; right now clarity of 
# understanding is more important than "efficiency"

# see what's next
# translation, show me the rest of the file after the first
# 103 rows (each row contains the name a a variable)
tail(the_index,-103)
# but since we just want to see the next group type we can
# pass the output on to just look at the first six rows
# using the pipe operator |> which is similar to the
# tidyverse %>%, but doesn't require loading the library
tail(the_index,-103) |> head()

# so emot_ is next up
emot <- make_var_frames("^emot_")
emot
# that gives 38 more variables, making 142 so far

tail(the_index,-142) |> head()

# so pain_ is next up
pain <- make_var_frames("^pain_")

# that's 48 more, so we'r at 190
tail(the_index,-190) |> head()

# si_ next
si <- make_var_frames("^si")
si     

tail(the_index,-222) |> head()

sa <- make_var_frames("^sa")
sa

tail(the_index,-249) |> head()

self <- make_var_frames("^self")
self

tail(the_index,-284) |> head()

social <- make_var_frames("^social_")
social

tail(the_index,-314)
# looks like the last four split differently

surv <- intake[,315:317]
sui_flag <- intake[,318]

# save these as objects in Rds format to be brought
# back into future scripts for further processing
# (reason: we could do everything in one big script
# but bite-size pieces are easier)

# since we've already seen how to do this one-at-a-time
# with saveRDS(something, file = "whatever") in the 
# recid.R file, here's a little razzle-dazzle

# see what's in "namespace"
ls()

# there are the ten new data frames and five others
# we are no longer using, but we can re-create from
# the script above, so lets rm remove them

rm(intake,make_var_frames,target,the_index,the_vars)

the_frames <- ls()

# make a function to save the data frames to Rds files

saveRDSobjects <- paste0(here::here("obj/"), the_frames, ".Rds")

for (i in seq_along(the_frames)) saveRDS(get(the_frames[i]), file = saveRDSobjects[i])

# explanation: for each of the names in the_frames save it with 
# the saveRDSobjects function; it's a bit magical; i is just the
# current index number, such as
the_frames[3]

# check that it worked
dir(here::here("obj"))

# and verify
foo <- readRDS(here::here("obj/child.Rds"))
foo
# always kill foo, junk, temp, etc. on sight; use this
# type of name for one-time convenience
rm(foo)

# all done here
# practice tip: make scripts do a finite task
# that's finite enough to keep in mind; if it
# grows much bigger than this without all the
# comments, it may be that too much is being
# bit off all at once; that's why I'm going
# to do further processing of the newly
# created data frames separately. Along the
# way I will probably write functions that can 
# applied to all of the others and eventually
# consolidate those into a func.R file to
# be imported with source(here::here("code/func.R))
# into other scripts if needed
