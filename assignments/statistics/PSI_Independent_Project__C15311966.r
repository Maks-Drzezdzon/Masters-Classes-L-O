library(tidyverse)
library(readxl) # read xlsx
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets
library(forecast)

# Maksymilian Drzezdzon

####################
# Data Exploration # 
####################

# loading data
df = read_excel('idepen_proj_stats.xlsx')
# basic exploration
head(df)
summary(df)
str(df)
colnames(df)
# how many missing values are in each col
map(df , ~sum(is.na(.)))

# looking at cols with potential problems 
unique(df$PHONE)
unique(df$...10) # found potential issues

unique(df$JOB) # found potential issues
unique(df$UNIVERSITY)
unique(df$SCHOOL_NAT)
unique(df$ACADEMIC_PROGRAM)

unique(df$EDU_FATHER) 
# found potential issues a field with a value of 0, 
# however this could indicate something else such as an absent parent, 
# it will be left as is
unique(df$OCC_FATHER) # found potential issues, ^
unique(df$EDU_MOTHER) # found potential issues, ^
unique(df$OCC_MOTHER) # found potential issues, ^
#########################
# variables of interest #
#########################

colnames(df)

# looking for odd values which can be found easily via unique, such as negative values on exams etc

unique(df$SISBEN) # found potential issues
unique(df$INTERNET)
unique(df$TV)
unique(df$COMPUTER)
unique(df$WASHING_MCH)
unique(df$CAR)
unique(df$MIC_OVEN)
unique(df$DVD)
unique(df$FRESH)
unique(df$PHONE)
unique(df$MOBILE)

# Saber 11 EXAMS - no issues found
unique(df$MAT_S11) # maths
unique(df$CR_S11) # critical reading
unique(df$CC_S11) # citizen competencies
unique(df$BIO_S11) # biology
unique(df$ENG_S11) # communication in English

# SABER PRO EXAMS - no issues found
unique(df$CR_PRO) # critical reading
unique(df$QR_PRO) # quantitative reasoning
unique(df$CC_PRO) # citizen competencies
unique(df$WC_PRO) # written communication
unique(df$ENG_PRO) # communication in English


#################
# Data Cleaning # 
#################

# column is completely empty and serves no purpose 
df = df[,!names(df) %in% c("...10")]

df$SISBEN[df$SISBEN == "0"] = "Level 0"
df$SISBEN[df$SISBEN == "It is not classified by the SISBEN"] = "Level NA"
df$SISBEN[df$SISBEN == "Esta clasificada en otro Level del SISBEN"] = "Level NA"

df$JOB[df$JOB == "0"] = "No"




write_feather(df, 'idepen_proj_stats.feather')
df = read_feather('idepen_proj_stats.feather')
df

