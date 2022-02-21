# recid.R
# Version 1.0.1 add 2003 baby names NOT READY
# create data frame for key to variable dem_urn
# motivation: dem_urn allows data to be traced to
# a specific survey response but will generally 
# not be needed otherwise, and an all-numeric
# record identification key, recid, allows
# easy selection of a particular record if it
# needs to be examined in isolation, and this
# variable both permits that and can also be
# used to retrieve the dem_url if needed
# author: Richard Careaga
# Date: 2022-02-08

# libraries

source(here("code/libr.R"))

# data

intake <- read_csv(here("data/2_DATA_Sample.csv"))

# main

recid <- intake[,1]
set.seed(42) # for replicability; otherwise values change
             # each time
recid$recid <- sample(1000:5000,nrow(intake),replace = FALSE)

# See comment 1 below

# reverse order of columns

recid <- recid[,c(2,1)]
# inspect
recid

# make a list of unique boys first names of boys born in 2003
# see comment 3 below

boynames <- read_excel(here("data/2003boys_tcm77-253990.xls"),sheet = excel_sheets(here("data/2003boys_tcm77-253990.xls"))[7])[3][[1]][-c(1:5)]

set.seed(42)                 
boynames <- sample(boynames,nrow(intake), replace = FALSE)

nicks <- data.frame(recid = recid[1], nicks = boynames)

# save three objects
# See comment 2 below

saveRDS(recid,file = here("obj/dem_urn_key.Rds"))
saveRDS(recid$recid, file = here("obj/recid.Rds"))
saveRDS(nicks, file = here("obj/nicks.Rds"))

# Comment 1 
# reverse order of columns
# the [ subset operator is mysterious but simple
# it specifies portions of a data frame by row,column
# this example selects all rows, because [empty,something]
# and all columns with the c (combine) function
# it is often much simpler than using tidy functions

# Comment2
# motivation: the .Rds format preserves the data frame
# and helps prevent inadvertent changes
# one will be the full recid object, called
# dem_urn_key.Rds
# and the other will be the record identifiers to be
# introduced as the first column of data frames
# derived from the original data

# the here() function allows referring to files relative to 
# the working directory for the project, rather than the
# current directory; good practice to use it

# Comment 3
# boysname is a list of given names of boys born in 
# England and Wales in 2003, taken from https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesenglandandwalesbabynamesstatisticsboys
# nick associates a given name with each recid; using 
# this is optional for interactive use to identify records
# each name is unique