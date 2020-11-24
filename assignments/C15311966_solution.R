library(tidyverse)

df = read_csv("data-file.csv")
df = read_table("read-data.csv")

# ToDo's

# 1) Clean the Data Set
# 2) relevant summary statistics, single visualisation that 
# captures the relationship between at least 3 of the original variables
# 3) Focus on a subset of the data and create 3 derived variables 
# for the purposes of answering a single question of interest.

# 1.) 1 file containing all code written during exam
# 2.) 1 much shorter file containing only the code to perform the 3 specific tasks.
# https://www.statmethods.net/graphs/scatterplot.html
############
# Cleaning #
############
colnames(df)
map(df , ~sum(is.na(.)))

# rename 
df = df %>% setnames(
  old = c(colnames(df)),
  new = c("jeff")
)

# drop cols
df = df[,!names(df) %in% c("col_name", "col_name")]

###############
# Exploration #
###############
fivenum()
head()
tail()
plot()
qqplot()
boxplot()

############
# Analysis #
############

# create 3 derived variables






