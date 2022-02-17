# func.R
# functions to be called in scripts
# author: Richard Careaga
# Date: 2022-02-15

# what R type is this object?
get_type <-function(x) typeof(x[[1]])

# largest number of characters in a data frame, by variable
find_max_char <- function(x,y) sapply(x[which(!is.na(x[y])),y], nchar) |> max()

# send most recently added column from last to first place
make_last_first <- function(x) x[,c(dim(x)[2],1:(dim(x)[2]-1))]

# convert "n/a" in descriptions of variables to NA
make_NA <- function(x) ifelse(x == "n/a",NA,x)

pretty_sql <- function(x) {
  # Connect to my-db as defined in ~/.my.cnf
  con <- DBI::dbConnect(RMariaDB::MariaDB(), group = "rs-dbi")
  kw <- DBI::dbGetQuery(con, "SELECT * FROM INFORMATION_SCHEMA.KEYWORDS;")
  DBI::dbDisconnect(con)
  mk_kw <- function(x) ifelse(toupper(x) %in% kw, toupper(x), tolower(x))
  x <- strsplit(x, " ")[[1]]
  holder <- vector()
  for (i in seq_along(x)) holder[i] <- mk_kw(x[i])
  paste(holder, collapse = " ")
}
