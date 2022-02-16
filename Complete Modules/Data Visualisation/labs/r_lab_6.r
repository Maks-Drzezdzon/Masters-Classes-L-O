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
df = read.csv("/Users/maksdrzezdzon/Documents/GitHub/Masters-Classes-L-O/Data Visualisation/data/OlympicGames.csv", sep = ",", header = T)


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

mapdata = map_data("world")
mapdata
# 1) What country has won most Silver medals since 2000?
df_year_2000 = with(df, df[(Year >= 2000),])

df_year_2000_tmp = sqldf('select Year, count(Medal) as Medal, Country from df_year_2000 where Medal == "silver" group by Country')
names(df_year_2000_tmp)[3] = "region"
df_year_2000_tmp
silver_medals = right_join(mapdata, df_year_2000_tmp, by="region")
silver_medals_sum = df_year_2000_tmp = sqldf('select count(Medal) as Medal from df_year_2000 where Medal == "silver"')


# ToDo add labels for countries



map1 = ggplot(silver_medals, aes( x = silver_medals$long, y = silver_medals$lat, group=group, fill = as.numeric(Medal))) +
  geom_polygon(color = "white") + labs(title="What country has won most Silver medals since 2000?", fill="Silver Medals count won since since year 2000")

map1


map1 = ggplot(silver_medals, aes( x = silver_medals$long, y = silver_medals$lat, group=group)) +
  geom_polygon(aes(fill = Medal), color = "black") + labs(title="What country has won most Silver medals since 2000?", fill="Silver Medals count won since since year 2000")

map1








# 5) What is the variation and spread of ages among gold and silver medalists?
tmp_df = df

tmp_df$DOB = year(strptime("11-11-2021", format = "%d-%m-%Y")) - year(strptime(tmp_df$DOB, format = "%d-%m-%Y"))
names(tmp_df)[1] = "Age"
tmp_df
medal_age = tmp_df %>% drop_na()
medal_age

medal_age_df = sqldf('select Athlete_Age, Medal from medal_age where Medal != "bronze"')
medal_age_df


plot = ggplot(data = medal_age_df, aes(Athlete_Age, Medal, fill=as.factor(Athlete_Age))) + 
  geom_col(position="dodge") + labs(x="Medal Name", y="Athlete Age", 
           title="Q5 What is the variation and spread of ages among gold and silver medalists?", fill="Athlete Age Range") + coord_flip()
plot

#names(medal_age)[1] = "region"
#names(medal_age)
#medal_age = right_join(mapdata, medal_age, by="region")





