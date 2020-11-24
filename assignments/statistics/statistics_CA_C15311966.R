# .m represents for maths tables and .p represents Portuguese  
student_pref = read_csv("sperformance-dataset.csv")
colnames(student_pref)

#################################### Hypothesis Question ######################################
# Does a student's parents' level of education influence their level of academic achievement? #
###############################################################################################

###########
## NOTES ##
###########

# sample vs population
# a sample is a piece of a population (selection of observations)
# a population might be all the people in a school or country
# that is so large that it would be impossible or too expensive 
# to collect data on each individual, to combat this a random sample is taken
# and used to make general conclusions about the population

### A few things can cause samples to vary from the population

## sampling error
# is when by chance, you happened to pick data/people that don't represent the average person
# e.g
# finding mean age in country
# sample mean is 50 and for the sake of argument the mean of the pop is 60
# this 10 years error is too great to be ignored and could have occurred because by chance the people in  
# the sample lead poorer lifestyles than your average person 

## selection bias
# this occurs when a sample is not randomly selected / not selected fairly
# e.g
# targeting a job ad to a specific website
# your sample is now based on that websites demographic alone
# only people that use said website will see that job ad

library(semTools) #For skewness and kurtosis
library(tidyverse) # useful tooling
library(skimr) # for descriptions
library(ggplot2) # plots
library(pastecs) # for descriptive statistic summaries
library(psych) # useful descriptive functions
library(semTools) #For skewness and kurtosis
library(FSA) #For percentage
library(car) # For Levene's test for homogeneity of variance 
library(effectsize) #To calculate effect size for t-test

####################
# Data exploration #
####################
student_pref = read_csv("sperformance-dataset.csv")
student_pref = na.omit(student_pref)

getmode <- function(v) {
        uniqv <- unique(v)
        uniqv[which.max(tabulate(match(v, uniqv)))]
}

# exploring data
glimpse(student_pref)
map(student_pref , ~sum(is.na(.)))
# max 382 students 184 male and 198 female
unique(student_pref$sex , incomparables = FALSE)
nrow(student_pref) # checking that rows add up
sum(as.integer(student_pref$sex == "M"))
sum(as.integer(student_pref$sex == "F"))
unique(student_pref$mG3)

# basic histogram for each col, missing data/completion rate 0-1, mean, standard of dev, percentiles 0-25-50-75-100
getmode(student_pref$mG3)
getmode(student_pref$Medu)
var(student_pref$Medu)

median(student_pref$mG3)
median(student_pref$Medu)

quantile(student_pref$mG3) # Q3 (14) - Q1 (8) = 6
quantile(student_pref$Medu) # Q3 (4) - Q1 (2) = 2


skim(student_pref)
skim(student_pref$Medu)
skim(student_pref$Fedu)




# wants to pursue higher education maths
# No - 18 Yes - 364
table(student_pref$higher.m)
# No - 18 Yes - 364
table(student_pref$higher.p)
# very few students dont want to pursue higher education 


###########
## ToDos ##
###########
# fields of interest 
# higher - wants to go to college - binary yes/no
# Medu - mothers education status - categorical and numeric
# mG1 and pG1 scores for maths and language tests - numeric 

### testing for normality 

## graphs and normality tests
# qq plot has stairs pattern meaning there are groups of values, makes sense
# QQ plot y = predicted value, x = actual value
# mothers education
qqnorm(student_pref$Medu, main = "Mothers education levels")
qqline(student_pref$Medu, col = "blue", lwd = 2)
# comment on sknewness and kurtosis
# calc standardized values
# app normality if between +/-2

# https://stats.stackexchange.com/questions/161591/how-to-interpret-this-qq-plot
# Maths results qq plots

# comment on sknewness and kurtosis
qqnorm(student_pref$mG3, main = "final period grade")
qqline(student_pref$mG3, col = "blue", lwd = 2)


# frequency distribution
hist(student_pref$Medu, col = "cornflowerblue", main = "Mothers education levels", ylab = "Person Count", xlab = "Mothers education")
hist(student_pref$Medu,
     breaks = 5,
     col = "cornflowerblue", 
     main = "Mothers education levels", 
     ylab = "% of People", 
     xlab = "Mothers education",
     prob = T)

# adding density curve
lines(density(student_pref$Medu), lwd = 2, col = "red")
# descriptive statistics 
mean(student_pref$Medu)
getmode(as.integer(student_pref$Medu))
median(sort(student_pref$Medu))

# examining final grade for CA
hist(student_pref$mG3, col = "cornflowerblue", main = "final period grade", ylab = "Person Count", xlab = "final pass grades")
# need to convert count area to density to then layer on a curve
hist(student_pref$mG3,
     col = "cornflowerblue", 
     main = "final period grade", 
     ylab = "% of People", 
     xlab = "final pass grades",
     prob = T)
# layer on density curve ontop
lines(density(student_pref$mG3), lwd = 2, col = "red")

mean(student_pref$mG3)
getmode(as.integer(student_pref$mG3))
median(sort(student_pref$mG3))
## box plot
boxplot(student_pref$mG3)


# skewness  = mean - median / std

### P value is the probability value



## Null hypothesis 
# for this pick a test such as pearson, shapiro-wilk, kolmogorov-smirnov and 
# if its parametric or not
# P > 0.05 Values are sampled from a population that follows normal distribution
# P =< 0.05 values are sampled from a population that does NOT follow normal distribution 

### parametric tests

# skewness and kurtosis z-values
# the closer to 0 the better

# skewness / std error
# kurtosis / std error
# should be between -/+ 1.96 

# shapiro-wilk test p-value
# null-H is that the data is normally distributed 
# so above 0.05, data is approx distributed
# it is rejected if it is below 0.05, is not approx distributed

# visual tests
# histogram, normal Q-Q plots and box plots
# these should show visually show that data is, well, normal


# outline proc for assesing normality
# key statistics used to ilustrate decison making
# graphs
# use statistical tests
# shapiro-wilks for small sampls
# kolmogorov-smirnov for large smaples > 50


#Get descriptive stastitics by group - output as a matrix
psych::describeBy(student_pref$Medu, student_pref$mG3, mat=TRUE)


## these dont work because they arent compatible

#Conduct Levene's test for homogeneity of variance in library car - the null hypothesis is that variances in groups are equal so to assume homogeneity we woudl expect probaility to not be statistically significant.
car::leveneTest(Medu ~ mG3, data=student_pref)
#Pr(>F) is your probability - in this case it is not statistically significant so we can assume homogeneity


#Conduct the t-test from package stats
#In this case we can use the var.equal = TRUE option to specify equal variances and a pooled variance estimate
stats::t.test(Medu ~ mG3, var.equal=TRUE, data=student_pref)
#No statistically significant difference was found
res = stats::t.test(Medu ~ mG3,var.equal=TRUE,data=student_pref)

#Calculate Cohen's d
#artithmetically
effcd = round((2*res$statistic)/sqrt(res$parameter), 2)

#Using function from effectsize package
effectsize::t_to_d(t = res$statistic, res$parameter)


#Eta squared calculation
effes=round((res$statistic*res$statistic)/((res$statistic*res$statistic)+(res$parameter)),3)
effes


###########
## NOTES ##
###########

# How do you use the t distribution and test statistic to determine whether to reject a null hypothesis?
# How do you use the normal distribution and a test statistic to determine whether to reject a null hypothesis?
# How do you use a probability distribution, a test statistic and critical values when trying to test a hypothesis?


# ctr+shift+c in windows

# # Attributes for both student-mat.csv (Math course) and student-por.csv (Portuguese language course) datasets:
# 1 school - student's school (binary: "GP" - Gabriel Pereira or "MS" - Mousinho da Silveira)
# 2 sex - student's sex (binary: "F" - female or "M" - male)
# 3 age - student's age (numeric: from 15 to 22)
# 4 address - student's home address type (binary: "U" - urban or "R" - rural)
# 5 famsize - family size (binary: "LE3" - less or equal to 3 or "GT3" - greater than 3)
# 6 Pstatus - parent's cohabitation status (binary: "T" - living together or "A" - apart)
# 7 Medu - mother's education (numeric: 0 - none,  1 - primary education (4th grade), 2 - 5th to 9th grade, 3 - secondary education or 4 - higher education)
# 8 Fedu - father's education (numeric: 0 - none,  1 - primary education (4th grade), 2 - 5th to 9th grade, 3 - secondary education or 4 - higher education)
# 9 Mjob - mother's job (nominal: "teacher", "health" care related, civil "services" (e.g. administrative or police), "at_home" or "other")
# 10 Fjob - father's job (nominal: "teacher", "health" care related, civil "services" (e.g. administrative or police), "at_home" or "other")
# 11 reason - reason to choose this school (nominal: close to "home", school "reputation", "course" preference or "other")
# 12 guardian - student's guardian (nominal: "mother", "father" or "other")
# 13 traveltime - home to school travel time (numeric: 1 - <15 min., 2 - 15 to 30 min., 3 - 30 min. to 1 hour, or 4 - >1 hour)
# 14 studytime - weekly study time (numeric: 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours)
# 15 failures - number of past class failures (numeric: n if 1<=n<3, else 4)
# 16 schoolsup - extra educational support (binary: yes or no)
# 17 famsup - family educational support (binary: yes or no)
# 18 paid - extra paid classes within the course subject (Math or Portuguese) (binary: yes or no)
# 19 activities - extra-curricular activities (binary: yes or no)
# 20 nursery - attended nursery school (binary: yes or no)
# 21 higher - wants to take higher education (binary: yes or no)
# 22 internet - Internet access at home (binary: yes or no)
# 23 romantic - with a romantic relationship (binary: yes or no)
# 24 famrel - quality of family relationships (numeric: from 1 - very bad to 5 - excellent)
# 25 freetime - free time after school (numeric: from 1 - very low to 5 - very high)
# 26 goout - going out with friends (numeric: from 1 - very low to 5 - very high)
# 27 Dalc - workday alcohol consumption (numeric: from 1 - very low to 5 - very high)
# 28 Walc - weekend alcohol consumption (numeric: from 1 - very low to 5 - very high)
# 29 health - current health status (numeric: from 1 - very bad to 5 - very good)
# 30 absences - number of school absences (numeric: from 0 to 93)
# 
# # these grades are related with the course subject, Math or Portuguese:
# 31 G1 - first period grade (numeric: from 0 to 20)
# 31 G2 - second period grade (numeric: from 0 to 20)
# 32 G3 - final grade (numeric: from 0 to 20, output target)
# 
# Additional note: there are several (382) students that belong to both datasets . 
# These students can be identified by searching for identical attributes
# that characterize each student, as shown in the annexed R file.

  