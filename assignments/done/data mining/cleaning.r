library(tidyverse)
library(lubridate)
library(data.table)

df = read.table("bank/bank-full.csv", header = T, sep = ";")
drop = c("poutcome", "previous", "pdays", "month", "contact", "day")
df = df[,!(names(df) %in% drop)]
df
write.csv(df, "bank-full-updated.csv", row.names = F)

df = read.table("bank/bank-full-updated.csv", header = T, sep = ",")
head(df)
unique(df$job , incomparables = FALSE)
unique(df$marital , incomparables = FALSE)
unique(df$education , incomparables = FALSE)
unique(df$default , incomparables = FALSE)
unique(df$balance , incomparables = FALSE)
unique(df$housing , incomparables = FALSE)
unique(df$loan , incomparables = FALSE)
unique(df$contact , incomparables = FALSE)
unique(df$day , incomparables = FALSE)
unique(df$month , incomparables = FALSE)
unique(df$duration , incomparables = FALSE)
unique(df$campaign , incomparables = FALSE)
unique(df$pdays , incomparables = FALSE)
unique(df$previous , incomparables = FALSE)
unique(df$poutcome , incomparables = FALSE)
unique(df$y , incomparables = FALSE)

names(df)[names(df) == "y"] = "subscribed_term_deposit"

df$subscribed_term_deposit[df$subscribed_term_deposit == "no"] = 0 
df$subscribed_term_deposit[df$subscribed_term_deposit == "yes"] = 1

df$job[df$job == "unknown"] = NA 
df$education[df$education == "unknown"] = NA 

df = na.omit(df)
write.csv(df, "bank-full-updated.csv", row.names = F)
head(df)
df = read.table("bank-full-updated.csv", header = T, sep = ",")
head(df)
