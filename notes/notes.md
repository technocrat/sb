data
{rdhs}
[NHANES](https://ehsanx.github.io/SPPH504007SurveyData/docs/importing-nhanes-to-r.html)
[Pew](https://www.pewresearch.org/download-datasets/)
MASS::survey
{srvyr}
[GSS](https://gss.norc.org/)
[happiness](https://archive.ics.uci.edu/ml/datasets/Somerville+Happiness+Survey)
[twitter suicide](https://www.nature.com/articles/s41746-020-0287-6)
[SentimentAnalysis](https://cran.r-project.org/web/packages/SentimentAnalysis/vignettes/SentimentAnalysis.html)
[Social media sentiment mining](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6111391/)

[curated tweets](https://raw.githubusercontent.com/AminuIsrael/Predicting-Suicide-Ideation/master/suicidal_data.csv)

# Big picture

1. Data collection
2. Data collation
3. Data schema creation
4. Data validation
5. Exploratory data analysis
6. Exploratory model analysis
7. Feature engineering
8. Model selection
9. Model results evaluation
10. Communication of results: tables, plots, LaTex

# schema

subj int
recid int sample(1000:5000,n, replace = false) # common
lookup c(subj,recid) # locked
pii c(recid, fields) # locked personally identifiable information, if any
q int chr fcts # each question has an identifier txt q1 ... qn
r recid q # responses
d recid d1 d2 d3, etc. # demographic fields

# https://towardsdatascience.com/building-a-suicidal-tweet-classifier-using-nlp-ff6ccd77e971

tweets <- readr::read_csv("https://raw.githubusercontent.com/AminuIsrael/Predicting-Suicide-Ideation/master/suicidal_data.csv")

[muliple imputation](https://rpubs.com/timothyfraser/multiple_imputation)