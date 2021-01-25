library(tidyverse)
library(data.table)
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets
library(forecast)
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


#########
# Notes #
#########
# BPN - business private network
# Network fault???




#########
#########
#########



df = read.csv("BPNDecomposedAutomated.csv", header = T)
help("write.csv")
write.csv(df, "BPNDecomposedAutomated.csv", row.names = F)

head(df)
colnames(df)
str(df)
glimpse(df)
df[df == "N/A"] = NA
map(df, ~sum(is.na(.)))

unique(df$MQHostName , incomparables = FALSE)
unique(df$MQManagerName , incomparables = FALSE)
unique(df$MQQueueName , incomparables = FALSE) 
unique(df$AgeDuration , incomparables = FALSE)
unique(df$DepthAlertDuration , incomparables = FALSE)
unique(df$ServiceStoppedDuration , incomparables = FALSE)
unique(df$URL , incomparables = FALSE)
unique(df$folderPath , incomparables = FALSE)
unique(df$fileName , incomparables = FALSE)
unique(df$date , incomparables = FALSE)
unique(df$time , incomparables = FALSE)
unique(df$location , incomparables = FALSE)
unique(df$busnessAlias , incomparables = FALSE)


unique(df$escalation_id , incomparables = FALSE)
unique(df$escalation_id.1 , incomparables = FALSE)

df = df[,!names(df) %in% c("location", "X1", "drop_me")]


