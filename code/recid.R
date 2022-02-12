# recid.R
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

# data
intake <- readr::read_csv(here::here("data/2_DATA_Sample.csv"))

# main

dim(intake)
colnames(intake)

recid <- intake[,1]
set.seed(42) # for replicability; otherwise values change
             # each time
recid$recid <- sample(1000:5000,nrow(intake),replace = FALSE)
# reverse order of columns
# the [ subset operator is mysterious but simple
# it specifies portions of a data frame by row,column
# this example selects all rows, because [empty,something]
# and all columns with the c (combine) function
# it is often much simpler than using tidy functions

recid <- recid[,c(2,1)]
# inspect
recid

# save two objects
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

saveRDS(recid,file = here::here("obj/dem_urn_key.Rds"))
saveRDS(recid$recid, file = here::here("obj/recid.Rds"))
