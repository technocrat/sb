# fdict.R
# version 1.0
# prepare field dictionary (field is synonymous with variable, which
# are columns; the row analog is record)
# convert sheet 1 of `3. Codebook.xlsx` 02/08/2022, 16:10:14
# to data frame for conversion to SQL, generate and save
# SQL script to create the table schema in SQL, run it
# from the terminal and read back into data frame
# author: Richard Careaga
# Date: 2022-02-14

# libraries

library(DBI)
library(RMariaDB)

# functions

source(here::here("code/func.R"))

# constants

# REVIEW
# can't simplify variable names by stripping dem_ etc.  
# because they become non-unique
# prefix_pattern <- "^[a-z]+_"

# data

# fdict = field dictionary
fdict <- readxl::read_excel(here::here("doc/3. Codebook.xlsx"))

# preprocessing

# save presentation names
header <- colnames(fdict)

# short variable names for use as data frame; 
colnames(fdict) <- c("variable","label","question","instrument","subscale","vartype","sum_name","subscale_r","rev_scoring","scoring","cutoff","scale","range_var","levels")

# presentation names can be restored for publication tables
# with colnames(fdict) <- header

# REVIEW
# can't simplify variable names by stripping dem_ etc.
# prefix_pattern <- "^[a-z]+_"
# unique(fdict$variable) |> length()
# length(gsub(prefix_pattern,"",fdict$variable) |> unique())

# all fdict variables are typeof character
sapply(fdict,typeof)

#maximum number of characters in question variable
sapply(fdict$question,nchar) |> max()
# can set char 256 for SQL
# if greater, must be varchar or text x where <= 2^16 - 1 = 65535
# and the sum of all character variables coded in
# SQL as varchar or text must be less than 65535

# total number of characters in each column is greater than 65535
nchar(fdict[1:14]) |> sum()

# now find the maximum lengthin each column
var_lengths <- vector()
for(i in seq_along(fdict)) var_lengths[i] = find_max_char(fdict,i)
# for this dataframe the variables have 271 or fewer characters, more than
# the 256 characters in their respective rows permitted by CHAR in SQL;
# ∴ VARCHAR(512) or TEXT, the next power of two will be needed
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
# In the terminal or terminal tab
# mysql -u root -pXXXXXXXX
# mysql use sui;
# note there are no quotations marks around the file name and no semicolon
# \. /home/roc/projects/sb/code/create_fdict.sql
# success will be indicated by
# Query OK, 0 rows affected (x sec) meaning table has no data yet

# open an SQL connection
con <- dbConnect(RMariaDB::MariaDB(), 
                 username="root", 
                 password="polytrope", 
                 dbname ="r")

# write the data 

dbWriteTable(con,"codebook",fdict, append = TRUE)

# read it back in
cb <- dbReadTable(con, "codebook")
# finished with data base connection, close
dbDisconnect(con)

# show table of variables and questions
cb[1:5,2:4]
