# friendly.R
# exercises from Discrete Data Analyis with R 
# Version 1.0: READY(ish)
# author: Richard Careaga
# Date: 2022-02-21
# 
library(vcd)
library(vcdExtra)

# case form 

names(Arthritis)
str(Arthritis)
head(Arthritis)

# frequency form

# Agresti (2002), table 3.11, p. 106
GSS <- data.frame(expand.grid(sex=c("female", "male"),
                  party=c("dem", "indep", "rep")),
                  count=c(279,165,73,47,225,191))
GSS

names(GSS)
str(GSS)


# table form

str(HairEyeColor)
sum(HairEyeColor)
dimnames(HairEyeColor)
sapply(dimnames(HairEyeColor), length)
sum(GSS$count)

# matrix form

## A 4 x 4 table Agresti (2002, Table 2.8, p. 57) Job Satisfaction
JobSat <- matrix(c(1,2,1,0, 3,3,6,1, 10,10,14,9, 6,7,12,11), 4, 4)
dimnames(JobSat) = list(income=c("< 15k", "15-25k", "25-40k", "> 40k"),
                        satisfaction=c("VeryD", "LittleD", "ModerateS", "VeryS"))
JobSat

JobSat <- as.table(JobSat)
str(JobSat)

# reordered (factor to integer)

dimnames(JobSat)$income <- c(7.5,20,32.5,60)
dimnames(JobSat)$satisfaction <- 1:4

# reordered (dark to light)
HairEyeColor <- HairEyeColor[, c(1,3,4,2), ]
str(HairEyeColor)

Arthritis$Improved <- ordered(Arthritis$Improved, levels=c("None", "Some", "Marked"))

# change dimensions

UCB <- aperm(UCBAdmissions, c(2, 1, 3))
dimnames(UCB)[[2]] <- c("Yes", "No")
names(dimnames(UCB)) <- c("Sex", "Admit?", "Department")
ftable(UCB)

strucplot(Arthritis, core = struct_assoc)
strucplot(Titanic, pop = FALSE)
grid.edit("rect:Class=2nd,Sex=Male,Age=Child,Survived=Yes",
          gp = gpar(fill = "red"))

# 3-way and larger

structable(HairEyeColor)
structable(Hair+Sex ~ Eye, HairEyeColor)
HSE <- structable(Hair+Sex ~ Eye, HairEyeColor) 
mosaic(HSE)

# using table

n <- 500
mydat <- data.frame(
  A = c(factor(sample(c("a1","a2"), n, rep=TRUE))),
  B = c(factor(sample(c("b1","b2"), n, rep=TRUE))),
  C = c(factor(sample(c("c1","c2"), n, rep=TRUE))))

mytable <- table(mydat$A,mydat$B) # A will be rows, B will be columns
margin.table(mytable, 1) # A frequencies (summed over B)
margin.table(mytable, 2) # B frequencies (summed over A)
prop.table(mytable) # cell percentages
prop.table(mytable, 1) # row percentages
prop.table(mytable, 2) # column percentages

# 3-Way Frequency Table
mytable <- table(mydat$A, mydat$B, mydat$C)
ftable(mytable)

# xtabs
# 3-Way Frequency Table
mytable <- xtabs(~ A + B + C, data=mydat)
ftable(mytable) # print table
# null: no significant difference between the observed proportions and the expected proportions.
summary(mytable) # chi-square test of independence

(GSStab <- xtabs(count ~ sex + party, data=GSS))
summary(GSStab)

# supressing factors
# case-form data frame, a frequency-form data frame (aggregate()), or a table-form array or table
# object (margin.table() or apply())

str(DaytonSurvey)
head(DaytonSurvey)

# data in frequency form
# collapse over sex and race
Dayton.ACM.df <- aggregate(Freq ~ cigarette+alcohol+marijuana,
                           data=DaytonSurvey, FUN=sum)
Dayton.ACM.df

# in table form
Dayton.tab <- xtabs(Freq~cigarette+alcohol+marijuana+sex+race, data=DaytonSurvey)
structable(cigarette+alcohol+marijuana ~ sex+race, data=Dayton.tab)

# table or array and for some purpose we want to reduce the
# number of levels of some factors by summing subsets of the frequencies

# create some sample data in frequency form
sex <- c("Male", "Female")
age <- c("10-19", "20-29", "30-39", "40-49", "50-59", "60-69")
education <- c("low", "med", "high")
data <- expand.grid(sex=sex, age=age, education=education)
counts <- rpois(36, 100) # random Possion cell frequencies
data <- cbind(data, counts)
# make it into a 3-way table
t1 <- xtabs(counts ~ sex + age + education, data=data)
structable(t1)
# collapse age to 3 levels, education to 2 levels
t2 <- collapse.table(t1,
                     age=c("10-29", "10-29", "30-49", "30-49", "50-69", "50-69"),
                     education=c("high", "high", "high"))
structable(t2)

# Convert the GSStab in table form to a data.frame in frequency form.
as.data.frame(GSStab)

Art.tab <-with(Arthritis, table(Treatment, Sex, Improved))
str(Art.tab)
Art.tab

# complex
tv.data <- read.table(system.file("extdata","tv.dat", package="vcdExtra"))
head(tv.data,5)

TV <- array(tv.data[,5], dim=c(5,11,5,3))
dimnames(TV) <- list(c("Monday","Tuesday","Wednesday","Thursday","Friday"),
                     c("8:00","8:15","8:30","8:45","9:00","9:15","9:30","9:45","10:00","10:15","10:30"),
                     c("ABC","CBS","NBC","Fox","Other"), c("Off","Switch","Persist"))
names(dimnames(TV))<-c("Day", "Time", "Network", "State")

TV <- TV[,,1:3,] # keep only ABC, CBS, NBC
TV <- TV[,,,3] # keep only Persist -- now a 3 way table
structable(TV)

TV.df <- as.data.frame.table(TV)
levels(TV.df$Time) <- c(rep("8:00-8:59",4),rep("9:00-9:59",4), rep("10:00-10:44",3))
TV2 <- xtabs(Freq ~ Day + Time + Network, TV.df)
structable(Day ~ Time+Network,TV2)

# Test of independence

# 2-Way Cross Tabulation
library(gmodels)
CrossTable(GSStab,prop.t=FALSE,prop.r=FALSE,prop.c=FALSE)

# chisq test

(HairEye <- margin.table(HairEyeColor, c(1, 2)))

chisq.test(HairEye)

# Fisher exact test
fisher.test(GSStab)
  
# exact tet unnecessary
fisher.test(HairEye)

# Cochran-Mantel-Haenszel χ2 chi test of the null
# hypothesis that two nominal variables are conditionally independent,
# results show no evidence of association of admittance and gender,
# stratified by department

mantelhaen.test(UCBAdmissions)

oddsratio(UCBAdmissions, log=FALSE)
lor <- oddsratio(UCBAdmissions) # capture log odds ratios
summary(lor)
woolf_test(UCBAdmissions)

col <- c("#99CCFF", "#6699CC", "#F9AFAF", "#6666A0", "#FF0000", "#000080")
fourfold(UCB,mfrow=c(2,3), color=col)

cotabplot(UCB, panel = cotab_fourfold)

doubledecker(Admit ~ Dept + Gender, data=UCBAdmissions[2:1,,])

plot(lor, xlab="Department", ylab="Log Odds Ratio (Admit | Gender)")

CMHtest(JobSat, rscores=c(7.5,20,32.5,60))

assocstats(GSStab)

GKgamma(JobSat)

(K <- Kappa(SexualFun))

agree <- agreementplot(SexualFun, main="Is sex fun?")
unlist(agree)

library(ca)
ca(HairEye)

plot(ca(HairEye), main="Hair Color and Eye Color")
title(xlab="Dim 1 (89.4%)", ylab="Dim 2 (9.5%)")

library(MASS)
# Independence model of hair and eye color and sex.
hec.1 <- loglm(~Hair+Eye+Sex, data=HairEyeColor)
hec.1

## Conditional independence
hec.2 <- loglm(~(Hair + Eye) * Sex, data=HairEyeColor)
hec.2

## Joint independence model.
hec.3 <- loglm(~Hair*Eye + Sex, data=HairEyeColor)
hec.3

anova(hec.1, hec.2, hec.3)

str(Mental)
xtabs(Freq ~ mental+ses, data=Mental) # display the frequency table

indep <- glm(Freq ~ mental + ses, family = poisson, data = Mental) # independence model
indep

Cscore <- as.numeric(Mental$ses)
Rscore <- as.numeric(Mental$mental)
# column effects model (ses)
coleff <- glm(Freq ~ mental + ses + Rscore:ses, family = poisson, data = Mental)
# row effects model (mental)
roweff <- glm(Freq ~ mental + ses + mental:Cscore, family = poisson, data = Mental)
# linear x linear association
linlin <- glm(Freq ~ mental + ses + Rscore:Cscore, family = poisson, data = Mental)

# compare models using AIC, BIC, etc
vcdExtra::LRstats(glmlist(indep, roweff, coleff, linlin))

anova(indep, linlin, coleff, test="Chisq")

CMHtest(xtabs(Freq~ses+mental, data=Mental))

RC1 <- gnm(Freq ~ mental + ses + Mult(mental,ses), data=Mental,
             family=poisson, , verbose=FALSE)
RC2 <- gnm(Freq ~ mental+ses + instances(Mult(mental,ses),2), data=Mental,
             family=poisson, verbose=FALSE)
anova(indep, RC1, RC2, test="Chisq")

# mosaic(Arthritis, gp = shading_max, split_vertical = TRUE, main="Arthritis: [Treatment] [Improved]")
# 
# mosaic plots, using plot.loglm() method
plot(hec.1, main="model: [Hair][Eye][Sex]")
plot(hec.2, main="model: [HairSex][EyeSex]")
plot(hec.3, main="model: [HairEye][Sex]")

dimnames(TV2)$Time <- c("8", "9", "10") # re-level for mosaic display
mosaic(~ Day + Network + Time, data=TV2, expected=~Day:Time + Network,
         legend=FALSE, gp=shading_Friendly)

mosaic(~ Day + Network + Time, data=TV2,
         expected=~Day:Time + Day:Network + Time:Network,
         legend=FALSE, gp=shading_Friendly)

long.labels <- list(set_varnames = c(mental="Mental Health Status", ses="Parent SES"))
mosaic(indep, ~ses+mental, residuals_type="rstandard",
         labeling_args = long.labels, labeling=labeling_residuals,
         main="Mental health data: Independence")

mosaic(linlin, ~ses+mental, residuals_type="rstandard",
         labeling_args = long.labels, labeling=labeling_residuals, suppress=1,
         gp=shading_Friendly, main="Mental health data: Linear x Linear")

