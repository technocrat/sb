# fdict.R
# version 1.4 verified READY
# prepare field dictionary 
# author: Richard Careaga
# Date: 2022-02-27

# libraries and functions

source("prepare.R")


# data

# fdict = field dictionary
# variables in the source data are represented by rows
# in the spreadsheet, with the columns representing
# attributes of the variables

fdict <- read_excel(here("doc/3. Codebook.xlsx"))

# preprocessing

# save presentation names
# 
header <- colnames(fdict)
saveRDS(header, file = here("obj/header.Rds"))

# short variable names for use as data frame
# naming is hard; the names should be long enough
# to be informative but short enough to be convenient

colnames(fdict) <- c("variable","label","question","instrument","subscale","vartype","sum_name","subscale_r","rev_scoring","scoring","cutoff","scale","range_var","levels")

# presentation names can be restored for publication tables
# with header <- readRDS("obj/header.RDS")

# all fdict variables are typeof character
sapply(fdict,typeof)

saveRDS(fdict,file=here("obj/fdict.Rds"))

