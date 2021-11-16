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

mapdata = map_data("world")
mapdata
# 1) What country has won most Silver medals since 2000?
df_year_2000 = with(df, df[(Year >= 2000),])

df_year_2000_tmp = sqldf('select Year, count(Medal) as Medal, Country from df_year_2000 where Medal == "silver" group by Country')
names(df_year_2000_tmp)[3] = "region"
df_year_2000_tmp
silver_medals = right_join(mapdata, df_year_2000_tmp, by="region")
silver_medals

# ToDo add labels for countries
map1 = ggplot(silver_medals, aes( x = long, y = lat, group=group)) +
  geom_polygon(aes(fill = Medal), color = "black")

map1




map1 = ggplot() +
  geom_map(aes(lat, long, map_id = Medal), map=silver_medals, color = "grey80", fill="grey30", size = 0.3)
map1




map2 = map1 + scale_fill_gradient(name = "Total Medals Won", low = "white", high = "blue", na.value = "grey50")+
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title.y=element_blank(),
        axis.title.x=element_blank(),
        rect = element_blank())
map2


# 2) How is the gender balance amongst the United States gold medalist? - Done
df_usa = with(df, df[(Country == "USA"),])
df_usa = with(df_usa, df_usa[(Medal == "gold"),])

df_usa_tmp = sqldf('select count(Gender) as Medal_Count, Medal, Gender from df_usa where Country="USA" group by Gender')
df_usa_tmp

plot = ggplot(data = df_usa_tmp, aes(Gender, Medal_Count, fill=as.factor(Gender))) +
  geom_col(position="dodge") + 
  labs(x="Genders", y="Medals Won", title="How is the gender balance amongst the United States gold medalist?", fill="Genders")

plot


# 3) What are the best sports for Sweden, USA, Austria and Switzerland? - Done

df_countires_list = with(df, df[(Country == c("USA", "Sweden", "Austria", "Switzerland")),])
df_countires_list_tmp = sqldf('select Event, count(Medal) as Medal_Count, Country from df_countires_list group by Country, Event')

plot = ggplot(data = df_countires_list_tmp, aes(Event, Medal_Count, fill=as.factor(Country))) +
  geom_col(position="dodge") + 
  labs(x="Event Name", y="Medals Won", title="What are the best sports for Sweden, USA, Austria and Switzerland?", fill="Country") + facet_wrap( ~ Country)

plot

print("I tried to filer by gold medals only to try and reduce the amount of columns but thats not enough")
df_countires_list = with(df, df[(Country == c("USA", "Sweden", "Austria", "Switzerland")),])
df_countires_list = with(df_countires_list, df_countires_list[(Medal == "gold"),])


df_countires_list_tmp = sqldf('select Event, count(Medal) as Medal_Count, Country from df_countires_list where Medal_Count != 0 group by Country, Event')


plot = ggplot(data = df_countires_list_tmp, aes(Event, Medal_Count, fill=as.factor(Country))) +
  geom_col(position="dodge") + 
  labs(x="Event Name", y="Medals Won", title="What are the best sports for Sweden, USA, Austria and Switzerland?", fill="Country") + facet_wrap( ~ Country)

plot


# 4) Who has the most total medals? - Done

medals_total = sqldf('select count(Medal) as Medal_Count, Country from df group by Country')
medals_total

plot = ggplot(data = medals_total, aes(Country, Medal_Count, fill=as.factor(Country))) +
  geom_col(position="dodge") + 
  labs(x="Country Name", y="Medals ", title="Who has the most total medals?", fill="Countries")

plot


# 5) What is the variation and spread of ages amongst gold and silver medalists?
tmp_df = df
tmp_df$DOB = year(strptime("11-11-2021", format = "%d-%m-%Y")) - year(strptime(tmp_df$DOB, format = "%d-%m-%Y"))
names(tmp_df)[1] = "Age"
tmp_df
medal_age = tmp_df %>% drop_na()
medal_age

medal_age = sqldf('select Athlete_Age, Medal from medal_age where Medal != "bronze"')
medal_age






