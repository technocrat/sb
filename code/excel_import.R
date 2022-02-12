
# read in '2. DATA_Sample.xlsx'
# xlsx:: syntax is for when you only plan on using a library once or a 
# few times in a script, so you can avoid library(readr)

# note that filenames with spaces present problems
# best practice is to use _ separator "2_DATA_Sample.xlsx"
# these didn't work
demog <- xlsx::read.xlsx(here::here("data/'2. DATA_Sample.xlsx'"),1, password = NULL)
# even though
dir("data")
# workaround fails to (even though dir() recognizes the file
demog <- xlsx::read.xlsx(dir("data")[1],1)
# changed file name in operating system
demog <- xlsx::read.xlsx(here::here('data/"2. DATA_Sample.xlsx"'),1)
# exported file to csv in operating system
demog <- readr::read_csv(here::here("data/2_DATA_Sample.csv"))
dim(demog)
