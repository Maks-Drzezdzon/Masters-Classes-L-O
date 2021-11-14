library(tidyverse)
library(sqldf)
library(eeptools)
library(Rcpp, "1.0.7")
library(reshape2)
library(viridis)
library(hrbrthemes)
library(lubridate)
library(reshape2)
library(maps)

# lab 8
df = read.csv("/Users/Grim/Documents/GitHub/Masters-Classes-L-O/Data Visualisation/data/OlympicGames.csv", sep= ',' , header=T )

df$gold = ifelse(is.na(df$gold), 0, df$gold)
df$silver = ifelse(is.na(df$silver), 0, df$silver)
df$bronze = ifelse(is.na(df$bronze), 0, df$bronze)

df

# 5. Visualisation Exercises
# Please answer the following questions. Use a visualisation to support the answer for each
# question. Experiment with the different types of charts and options ggplot offers. Please
# place the visualisations underneath each question.

# 1) What country has won most Silver medals since 2000? (2 marks)
# 2) How is the gender balance amongst the United States gold medalist? (2 marks)
# 3) What are the best sports for Sweden, USA, Austria and Switzerland? (2 marks)
# 4) Who has the most total medals? (2 marks)
# 5) What is the variation and spread of ages amongst gold and silver medalists? (2 marks)


# 1)
df_year_2000 = with(df, df[(Year >= 2000),])
df_year_2000 = with(df_year_2000, df_year_2000[(Medal == "silver"),])

df_year_2000
test_marks_2 = sqldf('select DOB, Subject, Name, round(avg(Mark_Written) + avg(Mark_Oral), 1)/2 as Test_mark from df group by Name, Subject')
plot = ggplot(data = df_year_2000, aes(Medal, Year, fill=as.factor(Country))) +
 geom_col(position="dodge") + labs(x="Silver Medals Won", y="Silver Medals Count",
             title="Q8-1 What country has won most Silver medals since 2000?", fill="Country Name")
plot
df_year_2000
ggplot(df_year_2000, aes(map_id = Country)) + geom_map(aes(fill = Medal), map = df_year_2000)

+ expand_limits(x = states_map$long, y = states_map$lat) + facet_wrap( ~ variable)




# 2) 
df_usa = with(df, df[(Country == "USA"),])
df_usa = with(df_usa, df_usa[(Medal == "gold"),])
df_usa

plot = ggplot(data = df_usa, aes(fill=as.factor(Gender))) +
geom_bar(x=Gender, position="dodge") + labs(x="Student Name", y="Grade Average", 
                                    title="Q8-2 How is the gender balance amongst the United States gold medalist?", fill="Subjects")
plot

ggplot (data=df_usa, fill=Gender) +
  geom_bar() + stat_count(x=df_usa$Gender)

# 3)




# 4)





# 5)




