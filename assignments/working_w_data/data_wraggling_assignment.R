library(tidyverse)
library(data.table)
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets
library(forecast)

df = read_feather('weather-data.feather')
sao_goncalo = filter(df, w_station_name == "SÃO GONÇALO")
itapira = as_tibble(filter(df, w_station_name == "ITAPIRA"))

###############
# ^^ Setup  ^^ #
###############




# main repo # https://github.com/Maks-Drzezdzon/Masters-Classes-L-O/tree/master/assignments/working_w_data
# file is small enough to hold in memory ~2gigs
# https://www.kaggle.com/PROPPG-PPG/hourly-weather-surface-brazil-southeast-region




##########################
# initial data wrangling #
##########################
# this section focuses on wrangling a csv file
# to produce a feather file used in further sections

df = read_csv('weather-data.csv')
spec(df)

# rename cols to be more descriptive 
df = df %>% setnames( 
  old = c(colnames(df)), 
  new = c( "station_id", "w_station_name", "elevation", "lat", "long", 
           "station_num", "city", "province", "observation_date_time", 
           "observation_date", "year", "month", "day", "hour", "precipitation_last_hr_ml",
           "air_pressure_hr_hPa", "max_air_pressure_hr_hPa", "min_air_pressure_hr_hPa", 
           "solar_radiation", "air_temprature", "dew_temp", "max_temp_hr", "max_dew_temp", 
           "min_temp_hr", "min_dew_temp", "relative_humidity", "max_relative_humidity", 
           "min_relative_humidity", "wind_speed", "wind_direction_rdegrees", "wind_gust_mps")
)

colnames(df)
# inspect unique weather station names, 122 as the file suggests
unique(df$w_station_name , incomparables = FALSE)

write_feather(df, 'weather-data.feather')
df = read_feather('weather-data.feather')

head(df)
colnames(df)
# need to fix time formats
typeof(df$observation_date) # integer
typeof(df$observation_date_time) # double

# construct dates/times and fill out any gaps then drop them as they arent needed
df %>% mutate(observation_date = make_date(year, month, day))
df %>% mutate(observation_date_time = make_datetime(year, month, day, hour)) 
# drop cols in c()
df = df[,!names(df) %in% c("year", "month", "day", "hour")]
head(df)
colnames(df)




####################
# data exploration #
####################
# this section focuses on exploring the data set
# and provide some insights for the written report
df = na.omit(df)
write_feather(df, 'weather-data.feather')
df = read_feather('weather-data.feather')
sao_goncalo = filter(df, w_station_name == "SÃO GONÇALO")


# missing data
map(df , ~sum(is.na(.)))
map(sao_goncalo , ~sum(is.na(.)))
map(itapira, ~sum(is.na(.)))
# df[row,col]
# explore data of one city 
View(sao_goncalo)
# dyplyr function, data set is too big for table()
glimpse(sao_goncalo)
# exploring other options
str(sao_goncalo)
summary(df)
summary(sao_goncalo$observation_date)
skim(sao_goncalo)

plot(sao_goncalo$observation_date_time, sao_goncalo$air_temprature)
hist( sao_goncalo$observation_date_time, sao_goncalo$air_temprature)

# this station has been in operation since 2008 more or less
# some data missing for 2009-2010, similar blip for 2011-2012
# there is also lots of 0 values during that time too
# there is very little data here, probably there was little rainfall
sao_goncalo_2008$precipitation_last_hr_ml %>% na.interp() %>% ets() %>% forecast(h=36) %>% autoplot()

plot(sao_goncalo$observation_date_time, sao_goncalo$precipitation_last_hr_ml)
plot(sao_goncalo$observation_date_time, sao_goncalo$relative_humidity)
plot(sao_goncalo$observation_date_time, sao_goncalo$solar_radiation)

# 12 month blocks
sao_goncalo_2008 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2008-12-31" & observation_date_time >= "2008-01-01"), ])
skim(sao_goncalo_2008)

sao_goncalo_2010 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2010-12-31" & observation_date_time >= "2010-01-01"), ])

skim(sao_goncalo_2010)

sao_goncalo_2012 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2012-12-31" & observation_date_time >= "2012-01-01"), ])
skim(sao_goncalo_2012)

sao_goncalo_2014 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2014-12-31" & observation_date_time >= "2014-01-01"), ])
skim(sao_goncalo_2014)

sao_goncalo_2016 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2016-12-31" & observation_date_time >= "2016-01-01"), ])
sim(sao_goncalo_2016)

par(mfrow=c(2,2)) # 2x2 block per graph
plot(type = "b", sao_goncalo_2008$observation_date_time, sao_goncalo_2008$dew_temp, xlab = "2008 12 month period" , ylab = "temperature in °C")
plot(type = "b", sao_goncalo_2008$observation_date_time, sao_goncalo_2008$precipitation_last_hr_ml, xlab = "2008 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2008$observation_date_time, sao_goncalo_2008$relative_humidity, xlab = "2008 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2008$observation_date_time, sao_goncalo_2008$solar_radiation, xlab = "2008 12 month period", ylab = "sunlight in  KJ/m2")

plot(type = "h", sao_goncalo_2010$observation_date_time, sao_goncalo_2010$dew_temp, xlab = "2010 12 month period", ylab = "temperature in °C")
plot(type = "b", sao_goncalo_2010$observation_date_time, sao_goncalo_2010$precipitation_last_hr_ml, xlab = "2010 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2010$observation_date_time, sao_goncalo_2010$relative_humidity, xlab = "2010 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2010$observation_date_time, sao_goncalo_2010$solar_radiation, xlab = "2010 12 month period", ylab = "sunlight in  KJ/m2")

plot(type = "h", sao_goncalo_2012$observation_date_time, sao_goncalo_2012$dew_temp, xlab = "2012 12 month period", ylab = "temperature in °C")
plot(type = "b", sao_goncalo_2012$observation_date_time, sao_goncalo_2012$precipitation_last_hr_ml, xlab = "2012 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2012$observation_date_time, sao_goncalo_2012$relative_humidity, xlab = "2012 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2012$observation_date_time, sao_goncalo_2012$solar_radiation, xlab = "2012 12 month period", ylab = "sunlight in  KJ/m2")

# quick inspection before forecasting
ggplot(data=sao_goncalo_2008, aes(x=solar_radiation, y=observation_date_time)) + geom_point() 
ggplot(data=sao_goncalo_2008, aes(x=solar_radiation, y=relative_humidity)) + geom_point()

ggplot(data=sao_goncalo_2010, aes(x=solar_radiation, y=observation_date_time)) + geom_point()
ggplot(data=sao_goncalo_2010, aes(x=solar_radiation, y=relative_humidity)) + geom_point()

ggplot(data=sao_goncalo_2012, aes(x=solar_radiation, y=observation_date_time)) + geom_point()
ggplot(data=sao_goncalo_2012, aes(x=solar_radiation, y=relative_humidity)) + geom_point()

# this forecast isnt very useful as it creates a flat line, similar results for other years
sao_goncalo_2008$precipitation_last_hr_ml %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()
sao_goncalo_2008$relative_humidity %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()
sao_goncalo_2008$solar_radiation %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()


#################################################
# find temperature changes in the same location # 
#################################################

temp_2008 = sapply(sao_goncalo_2008, max, na.rm = T)
highest_max_temp_2008 = getElement(temp_2008, "max_temp_hr")             
lowest_max_temp_2008 = getElement(temp_2008, "min_temp_hr")
# highest max temp is 31.2
# lowest max temp is 28.9

temp_2010 = sapply(sao_goncalo_2010, max, na.rm = T)
highest_max_temp_2010 = getElement(temp_2010, "max_temp_hr")
lowest_max_temp_2010 = getElement(temp_2010, "min_temp_hr")
# highest max temp is 33.5
# lowest max temp is 31.8

temp_2012 = sapply(sao_goncalo_2012, max, na.rm = T)
highest_max_temp_2012 = getElement(temp_2012, "max_temp_hr")
lowest_max_temp_2012 = getElement(temp_2012, "min_temp_hr")
# highest max temp is 34.6
# lowest max temp is 29

temp_2014 = sapply(sao_goncalo_2014, max, na.rm = T)
highest_max_temp_2014 = getElement(temp_2014, "max_temp_hr")
lowest_max_temp_2014 = getElement(temp_2014, "min_temp_hr")
# highest max temp is 35.6
# lowest max temp is 31.5

temp_2016 = sapply(sao_goncalo_2016, max, na.rm = T)
highest_max_temp_2016 = getElement(temp_2016, "max_temp_hr")
lowest_max_temp_2016 = getElement(temp_2016, "min_temp_hr")
# highest max temp is 35.5
# lowest max temp is 31.3
highest_temps =  c(highest_max_temp_2008, highest_max_temp_2010, highest_max_temp_2012, highest_max_temp_2014, highest_max_temp_2016)
names(highest_temps) = c("2008", "2010", "2012", "2014", "2016")

lowest_temps = c(lowest_max_temp_2008, lowest_max_temp_2010, lowest_max_temp_2012, lowest_max_temp_2014, lowest_max_temp_2016)
names(lowest_temps) = c("2008", "2010", "2012", "2014", "2016")

# Graph it and compare changes

plot(lowest_temps, xaxt="n", xlab = "Lowest Temperature recorded every 2 years", ylab = "Degrees in Celsius")
axis(1, at = 1:5, labels = names(lowest_temps))

plot(highest_temps, xaxt="n", xlab = "Lowest Temperature recorded every 2 years", ylab = "Degrees in Celsius")
axis(1, at = 1:5, labels = names(highest_temps))

##################################
# find most and least rainy city #
##################################
# might be better to use group by here and graph it ?

sapply(df, max, na.rm = T)
# max  is 100

most_rainy_city = filter(df, precipitation_last_hr_ml >= 100)
skim(most_rainy_city)


sapply(df, min, na.rm = T)
# min 0

least_rainy_city = filter(df, precipitation_last_hr_ml >= 0)
skim(least_rainy_city)



##################################
# find most and least humid city #
##################################
# might be better to use group by here and graph it ?

sapply(df, max, na.rm = T)
# max 
most_humid_city = filter(df, relative_humidity >= 100)
skim(most_humid_city)


sapply(df, min, na.rm = T)
# min 

least_humid_city = filter(df, relative_humidity >= 0)
skim(least_humid_city)


# Air pressure and wind analysis maybe ?

