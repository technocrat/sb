# fdict.R
# version 1.01 touchups READY after mysql installed
# prepare field dictionary (field is synonymous with variable, which
# are columns; the row analog is record)
# SQL script to create the table schema in SQL, 
# author: Richard Careaga
# Date: 2022-02-18

# libraries

source(here("code/libr.R"))

# functions

source(here::here("code/func.R"))

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

#maximum number of characters in question variable
sapply(fdict$question,nchar) |> max()

# See comment 1 below

# is total number of characters in each column is greater than 65535?
nchar(fdict[1:14]) |> sum()

# now find the maximum length in each column

var_lengths <- vector()
for(i in seq_along(fdict)) var_lengths[i] = find_max_char(fdict,i)

max(var_lengths)
# which will fit within the 65535 cap
max(var_lengths) * dim(fdict)[2] < 2^16 - 1

# syntax to create variable declaration in SQL syntax

declaration <- rep("TEXT,",dim(fdict)[2])
tab_body <- data.frame(variable = colnames(fdict),vartype = declaration)

# remove comma from last row and replace with );

tab_body[dim(tab_body)[1],2] <- gsub(",",");",tab_body[dim(tab_body)[1],2])

# combine the two columns

spec <- paste(tab_body$variable,tab_body$vartype)
forepart <- "CREATE TABLE codebook(\nid INT AUTO_INCREMENT PRIMARY KEY,"

# write the script to create the data table

cat(c(forepart,spec),file=here::here("code/create_fdict.sql"),sep="\n")

# See comment 3 below for how to use the file; this step is needed
# before next two statements

# open an SQL connection
con <- open_sql("PASSWORD")

# write the data 

dbWriteTable(con,"codebook",fdict, append = TRUE)

# read it back in
# 
cb <- dbReadTable(con, "codebook")

# finished with data base connection, close
close_sql()

# show table of selected variable values in first 5 rows
# and selected questions in second, third and fourth columns

cb[1:5,2:4]

# Comment 1
# can set char 256 for SQL
# if greater, must be varchar or text x where <= 2^16 - 1 = 65535
# and the sum of all character variables coded in
# SQL as varchar or text must be less than 65535

# Comment 2 
# for this dataframe the variables have 271 or fewer characters, more than
# the 256 characters in their respective rows permitted by CHAR in SQL;
# ∴ VARCHAR(512) or TEXT, the next power of two will be used 2^9 is 512

# Comment 3
# In the terminal tab or the terminal app
# $ mysql -u root -pXXXXXXXX
# $ mysql use sui;
# note there are no quotations marks around the file name and no semicolon
# \. /home/roc/projects/sb/code/create_fdict.sql
# success will be indicated by
# Query OK, 0 rows affected (x sec) meaning table has no data yet