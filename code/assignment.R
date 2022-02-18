# assignment.R
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
codebook <- dbReadTable(con, "codebook")

# read in the entire file

intake <- get_intake()

# examine column names

the_vars <- colnames(intake)
the_vars

cb <- data.frame(text = strsplit(readtext(here::here("doc/Character Variables.docx"))$text,"\n"))
colnames(cb) <- "variable"

# close up white space

cb$variable <- str_trim(cb$variable,"both")
cb$factor <- ifelse(str_detect(cb$variable,"-.*^"),TRUE,FALSE)
str_remove("-.*$",cb$variable)

# sui_flag

sui <- readRDS(here("obj/sui_flag.Rds"))
get_type(sui)

# inspect

head(sui)
# TODO ask SB
# to be converted to factor ?



