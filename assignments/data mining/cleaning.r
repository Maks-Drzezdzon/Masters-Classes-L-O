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
unique(df$education , incomparables = FALSE)
names(df)[names(df) == "y"] = "subscribed_term_deposit"

df$subscribed_term_deposit[df$subscribed_term_deposit == "no"] = 0 
df$subscribed_term_deposit[df$subscribed_term_deposit == "yes"] = 1

df$job[df$job == "unknown"] = NA 
df$education[df$education == "unknown"] = NA 

df = na.omit(df)
write.csv(df, "bank-full-updated.csv", row.names = F)
head(df)
