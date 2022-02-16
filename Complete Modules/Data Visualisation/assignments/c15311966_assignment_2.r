library(tidyverse)
library(sqldf)
library(eeptools)
library(Rcpp, "1.0.7")
library(reshape2)
library(viridis)
library(hrbrthemes)
library(lubridate)
library(reshape2)
library(randomcoloR)
#library(patchwork)

# policy_df = read.csv("/Users/Grim/Documents/GitHub/covid19/Policy.csv", sep= ',' , header=T ) # after examining data this file isnt going to be used here
# seoul_floating_df = read.csv("/Users/Grim/Documents/GitHub/covid19/SeoulFloating.csv", sep= ',' , header=T ) # after examining data this file isnt going to be used here
# time_gender_df = read.csv("/Users/Grim/Documents/GitHub/covid19/TimeGender.csv", sep= ',' , header=T ) # there isnt a way to connect this data back to the rest 


# Data setup --
cases_per_province_with_date_df = read.csv("/Users/Grim/Documents/GitHub/covid19/TimeProvince.csv", sep= ',' , header=T )
weather_df = read.csv("/Users/Grim/Documents/GitHub/covid19/Weather.csv", sep= ',' , header=T )
covid_tests_pos_neg_and_time_df = read.csv("/Users/Grim/Documents/GitHub/covid19/Time.csv", sep= ',' , header=T )
confrimed_cases_age_group_timeline_df = read.csv("/Users/Grim/Documents/GitHub/covid19/TimeAge.csv", sep= ',' , header=T )
region_df = read.csv("/Users/Grim/Documents/GitHub/covid19/Region.csv", sep= ',' , header=T )
search_trends_df = read.csv("/Users/Grim/Documents/GitHub/covid19/SearchTrends.csv", sep= ',' , header=T )
case_df = read.csv("/Users/Grim/Documents/GitHub/covid19/Case.csv", sep= ',' , header=T )
patient_info_df = read.csv("/Users/Grim/Documents/GitHub/covid19/PatientInfo.csv", sep= ',' , header=T )


# subset(df_here, select = -c(cols_to_remove))

# pre-setup
# changing color palette setup
n_color = 22
set.seed(2643599)
palette = distinctColorPalette(n_color)
palette

# test palette
# http://www.sthda.com/english/wiki/ggplot2-colors-how-to-change-colors-automatically-and-manually
# scale_fill_manual() for box plot, bar plot, violin plot, etc
# scale_color_manual() for lines and points

pie(rep(1, n_color),
    col=palette,
    radius=1,
    main="test palette")

# data prep

# find most infected areas
colnames(case_df)
most_infected_areas = subset(case_df, select = -c(case_id, latitude, longitude))
most_infected_areas_sum = sqldf("select province as Province, sum(confirmed) as 'Confrimed Infections' from most_infected_areas group by province")


most_infected_areas_sum_plot = ggplot(data = most_infected_areas_sum, aes(Province, `Confrimed Infections`, fill=as.factor(Province))) +
  geom_col(position="dodge") + 
  labs(x="Province Name", y="Confrimed Infections Count", title="What are the most infected areas?", fill="Province")
most_infected_areas_sum_plot


# pick out top 4 hot spots
hotspots_df = sqldf("select * from most_infected_areas where province == 'Daegu' or province == 'Seoul' or province == 'Gyeonggi-di' or province == 'Gyeongsangbuk-do'")
hotspots_df = sqldf("select * from hotspots_df where confirmed >= 30")
hotspots_df
colnames(hotspots_df)[4] = "Infected_In_Location"
tmp_df_for_data_vis = hotspots_df
hotspots_df
# Group vs non group infections
tmp_df_for_data_vis[tmp_df_for_data_vis == TRUE] = "Group Related Infection"
tmp_df_for_data_vis[tmp_df_for_data_vis == FALSE] = "Not Group Related Infection"

plot_for_assign_requirements_1 = ggplot(data=tmp_df_for_data_vis, aes(reorder(province, confirmed), confirmed, fill=reorder(Infected_In_Location, confirmed))) +
  scale_fill_manual(values = c(palette)) +
  geom_bar(stat="identity", color="black", position=position_dodge())+
  theme_minimal() +
  facet_wrap(~group) +
  labs(x="Province Name", y="Confirmed Infections", title="Where and how are infections spreading the most in Korea during 2020?", fill="Reported area of infection")
plot_for_assign_requirements_1


# Looks like a lot of infections are the cause of group gatherings in churches - this should be avoided if possible 

# which groups spread it the most and does weather have an effect?
sapply(weather_df_2020, class)
colnames(weather_df)

# start

weather_df_filtered = sqldf("select * from weather_df where province == 'Daegu' or province == 'Seoul' or province == 'Gyeonggi-di' or province == 'Gyeongsangbuk-do'")

tmp_weather = drop_na(weather_df_filtered)

# filter the dates to match confrimed_cases_age_group_timeline_df
tmp_weather = subset(tmp_weather, date > "2020-03-01")
class(tmp_weather$date)

tmp_weather$date = as.Date(tmp_weather$date, format = "%Y-%m-%d")
tmp_weather

weather_plot_3_hotspots = ggplot() +
  geom_line(data=tmp_weather, aes(x=date, y=avg_temp, group=province, colour=province), stat="identity") + labs(x="date", y="avg_temp", 
                      title="which groups spread it the most and does weather have an effect?", fill="province")
weather_plot_3_hotspots


confrimed_cases_age_group_timeline_df = read.csv("/Users/Grim/Documents/GitHub/covid19/TimeAge.csv", sep= ',' , header=T )

# whos spreading them?
confrimed_cases_age_group_timeline_df
colnames(confrimed_cases_age_group_timeline_df)[3] = "age_group"
confrimed_cases_age_group_timeline_df$date = as.Date(confrimed_cases_age_group_timeline_df$date, format = "%Y-%m-%d")

plot_for_assign_requirements_2 = ggplot() +
  geom_bar(data=confrimed_cases_age_group_timeline_df, aes(x=date, y=confirmed, color="#A4A4A4"), stat="identity", color="black", position=position_dodge())+
  facet_wrap(~age_group) +
  labs(x="Month of the year", y="Confirmed Infections", title="Which age group got infected the most during the months of March to July?", 
       fill="")
plot_for_assign_requirements_2

# patchwork functionality allows to add plots to display them side by side
# however im not sure if id loose marks for this
plot_for_assign_requirements_2 + weather_plot_3_hotspots



ggplot() +
  geom_bar(data=confrimed_cases_age_group_timeline_df, aes(x=date, y=confirmed, fill="blue") , stat="identity") +
  facet_wrap(~age_group) +
  scale_fill_manual(values = c(palette)) +
  geom_point(data=tmp_weather, aes(x=date, y=avg_temp, group=province, colour=province), position = position_dodge(width = 0.9), shape=3, size=5, show.legend=FALSE)


# now combine iterations to 1 viz  
colnames(tmp_weather)[2] = "Province Temperature"

pie(rep(1, n_color),
    col=palette,
    radius=1,
    main="test palette") 

colnames(cases_per_province_with_date_df)
tmp = sqldf("select date, province, confirmed from cases_per_province_with_date_df where province == 'Daegu' or 
                                        province == 'Seoul' or province == 'Gyeonggi-do' or province == 'Gyeongsangbuk-do'")

tmp
confrimed_cases_age_group_timeline_df
ggplot() + 
  geom_bar(data=cases_per_province_with_date_df, aes(x=date, y=confirmed, fill = "blue"), size = 1, stat="identity", position="stack", show.legend=FALSE) +
  scale_fill_manual(values = c(palette)) +
  facet_wrap(~age_group) +
  labs(x="Month Of The Year", y="Confirmed Infections", title="In which age group did infections increase when compared to average temperatures in most infected areas?", fill=" ") + 
  geom_line(data=tmp_weather, aes(x=date, y=100*avg_temp, group=`Province Temperature`, colour=`Province Temperature`), size=1.5)+ 
  scale_y_continuous(sec.axis = sec_axis(~./100, name = "Temperature per month °C"))




region_df = read.csv("/Users/Grim/Documents/GitHub/covid19/Region.csv", sep= ',' , header=T )
case_df = read.csv("/Users/Grim/Documents/GitHub/covid19/Case.csv", sep= ',' , header=T )

most_infected_areas_sum_plot = ggplot(data = most_infected_areas_sum, aes(Province, `Confrimed Infections`, fill=as.factor(Province))) +
  geom_col(position="dodge") + 
  labs(x="Province Name", y="Confrimed Infections Count", title="What are the most infected areas?", fill="Province")
most_infected_areas_sum_plot

region_df
tmp_df = sqldf("select province, sum(elderly_population_ratio) as elderly_population_ratio, sum(elderly_alone_ratio) as elderly_alone_ratio from region_df where province == 'Daegu' or 
                                        province == 'Seoul' or province == 'Gyeonggi-do' or province == 'Gyeongsangbuk-do' group by province")

tmp_df

tmp_df_2 = sqldf("select province, elderly_population_ratio, elderly_alone_ratio from region_df where province == 'Daegu' or 
                                        province == 'Seoul' or province == 'Gyeonggi-do' or province == 'Gyeongsangbuk-do'")

tmp_df_2

living_alone_elderly_population = ggplot(data = tmp_df, aes(province, elderly_alone_ratio , fill=elderly_alone_ratio)) +
  geom_col(position="dodge") + 
  labs(x="Province Name", y="elderly population ratio %", title="Elderly vs elderly living alone population", fill="elderly living alone %")
living_alone_elderly_population


# **************************************************

    
    
    