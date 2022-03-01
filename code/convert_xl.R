# convert_xl.R
# import Excel into data frame
# Version 1.0
# author: Richard Careaga
# Date: 2022-02-27

# libraries and functions

source("prepare.R")

# data

intake <- read_xlsx(here("data/2_DATA_Sample.xlsx"))

# save as R data frame

saveRDS(intake,here("obj/intake.Rds"))
