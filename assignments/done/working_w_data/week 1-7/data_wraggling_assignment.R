needed_packages <- c("tidyverse", "data.table", "feather", "lubridate", "reticulate", "skimr", "forecast")                      
# Extract not installed packages
not_installed <- needed_packages[!(needed_packages %in% installed.packages()[ , "Package"])]    
# Install not installed packages
if(length(not_installed)) install.packages(not_installed)


library(tidyverse)
library(data.table)
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets
library(forecast)

df = read_feather('weather-data.feather')
sao_goncalo = as_tibble(filter(df, w_station_name == "S�O GON�ALO"))
sao_paulo = as_tibble(filter(df, w_station_name == "S�o Paulo"))
df = read_feather('backup-weather-data.feather')

########################################
# ^^ Quick Setup for me to run code ^^ #
########################################



##########################
# initial data wrangling #
##########################
# this section focuses on wrangling a csv file
# to produce a feather file used in further sections

#############
# Dataset 1 #
#############
# there was a 4th csv that i didnt load because the data from it was not needed, only to be dropped later in the 3rd data set
# it contained wind metrics that i didnt use in this analysis 

weather_stations_codes = read.table('weather_stations_codes.csv',  header = T, sep = ";")

colnames(weather_stations_codes)
# isolating important cols
weather_stations_codes = weather_stations_codes %>% setnames(
 c("w_station_name", "station_id", "drop_me", "drop_me_2", "drop_me_3", "drop_me_4", "observation_date")
  
)
# drop redundant cols
weather_stations_codes = weather_stations_codes[,!names(weather_stations_codes) %in% c("drop_me", "drop_me_2", "drop_me_3", "drop_me_4")]
colnames(weather_stations_codes)

weather_stations_codes = na.omit(weather_stations_codes)
write_feather(weather_stations_codes, 'weather_stations_codes.csv.feather')
weather_stations_codes = read_feather('weather_stations_codes.csv.feather')

#############
# Dataset 2 #
#############

conventional_weather_stations = read.table('conventional_weather_stations_inmet_brazil_1961_2019.csv', header = T , sep = ";")

colnames(conventional_weather_stations)
head(conventional_weather_stations)

conventional_weather_stations = conventional_weather_stations %>% setnames(
  old = c(colnames(conventional_weather_stations)),
  new = c("station_id", "observation_date", "hour", 
          "precipitation_last_hr_mm", "dry_temp", "wet_temp",
          "max_temp_hr", "min_temp_hr", "relative_humidity", "pressure",
          "pressure_sea_level", "wind_direction", "wind_speed", "insolation",
          "cloudiness", "evaporation", "avg_temp_compensated", "avg_rel_humidity",
          "avg_wind_speed", "temp")
  
)
colnames(conventional_weather_stations)
head(conventional_weather_stations)
conventional_weather_stations = conventional_weather_stations[,!names(conventional_weather_stations) %in% c("hour", "dry_temp", "wet_temp", 
                                                                                       "relative_humidity", "pressure", "pressure_sea_level",
                                                                                       "wind_direction", "wind_speed", "insolation",
                                                                                       "cloudiness", "evaporation", "avg_temp_compensated", "avg_rel_humidity",
                                                                                       "avg_wind_speed", "temp")]

colnames(conventional_weather_stations)
head(conventional_weather_stations)
write_feather(conventional_weather_stations, 'conventional_weather_stations.feather')
weather_stations = read_feather('conventional_weather_stations.feather')


######################
# Combine DS 1 and 2 #
######################
weather_stations_codes = read_feather('weather_stations_codes.csv.feather')
weather_stations = read_feather('conventional_weather_stations.feather')
head(weather_stations_codes)
head(weather_stations)

weather_codes_stations = merge(weather_stations_codes, weather_stations, by = c("station_id", "observation_date"))
# final clean up before merg with 3rd data set
weather_codes_stations = weather_codes_stations[,!names(weather_codes_stations) %in% c("station_id", "max_temp_hr", "min_temp_hr")]

write_feather(weather_codes_stations, "weather_codes_stations.feather")

#############
# Dataset 3 #
#############

df = read_csv('weather-data.csv')

# rename cols to be more descriptive
colnames(df)
df = df %>% setnames( 
  old = c(colnames(df)), 
  new = c( "station_id", "w_station_name", "elevation", "lat", "long", 
           "station_num", "city", "province", "observation_date", 
           "observation_date", "year", "month", "day", "hour", "precipitation_last_hr_mm",
           "air_pressure_hr_hPa", "max_air_pressure_hr_hPa", "min_air_pressure_hr_hPa", 
           "solar_radiation", "air_temprature", "air_temprature", "max_temp_hr", "max_air_temprature", 
           "min_temp_hr", "min_air_temprature", "relative_humidity", "max_relative_humidity", 
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
typeof(df$observation_date) # double

# construct dates/times and fill out any gaps then drop them as they arent needed
df %>% mutate(observation_date = make_date(year, month, day))
df %>% mutate(observation_date = make_datetime(year, month, day, hour)) 
# drop cols in c()
df = df[,!names(df) %in% c("year", "month", "day", "hour", 
                           "max_relative_humidity", "drop_me", 
                           "air_pressure_hr_hPa",
                           "max_air_pressure_hr_hPa", "min_air_pressure_hr_hPa",
                           "elevation", "lat", "long", "preassure", "province",
                           "city", "max_air_temprature", "min_air_temprature", "observation_date",
                           "station_id", "wind_direction_rdegrees", "wind_gust_mps",
                           "wind_speed", "station_num", "min_relative_humidity")]
head(df)
colnames(df)
# after further analysis there were so many 0 values in air temperature that it skewed the average to below 10 degrees
# the decision was made to treat this as noise and remove it from the data set
df$air_temprature[df$air_temprature < 1] = NA
df = na.omit(df)
write_feather(df, 'weather-data.feather')
df = read_feather('weather-data.feather')


###############################################
# Merge dataset 3 and amalgimation of 1 and 2 #
###############################################

weather_codes_stations = read_feather("weather_codes_stations.feather")
df = read_feather('weather-data.feather')

# strsplit(weather_codes_stations$w_station_name, " ")[[1]][1]
weather_codes_stations=separate(weather_codes_stations, w_station_name, sep = " ", into = c("w_station_name","drop_2","drop_3"))
na.omit(weather_codes_stations)
weather_codes_stations = weather_codes_stations[,!names(weather_codes_stations) %in% c("drop_2","drop_3")]
weather_codes_stations

temp = merge(weather_codes_stations, df, by = c("w_station_name", "observation_date", "precipitation_last_hr_mm"), all = T)
na.omit(temp)

write_feather(df, 'backup-weather-data.feather')
write_feather(temp, 'weather-data.feather')

df = read_feather('weather-data.feather')

####################
# data exploration #
####################
# this section focuses on exploring the data set
# and provide some insights for the written report

df = read_feather('weather-data.feather')
sao_goncalo = filter(df, w_station_name == "S�O GON�ALO")
head(sao_goncalo)

# checking missing data 

map(df , ~sum(is.na(.)))
map(sao_goncalo , ~sum(is.na(.)))
map(sao_paulo, ~sum(is.na(.)))
View(sao_goncalo)

# dyplyr function, data set was too big for table()
glimpse(sao_goncalo)
glimpse(sao_paulo)
str(sao_goncalo)
str(sao_paulo)
summary(df)
summary(sao_goncalo$observation_date)
summary(sao_paulo$precipitation_last_hr_mm)
skim(sao_goncalo)

plot(sao_goncalo$observation_date, sao_goncalo$air_temprature)
hist( sao_goncalo$observation_date, sao_goncalo$air_temprature)

# this station has been in operation since 2008 more or less
# some data missing for 2009-2010, similar blip for 2011-2012
# there is also lots of 0 values during that time too
# there is very little data here, probably there was little rainfall

plot(sao_goncalo$observation_date, sao_goncalo$precipitation_last_hr_mm)
plot(sao_goncalo$observation_date, sao_goncalo$relative_humidity)
plot(sao_goncalo$observation_date, sao_goncalo$solar_radiation)

# 12 month blocks
sao_goncalo_2008 = with(sao_goncalo, sao_goncalo[(observation_date <= "2008-12-31" & observation_date >= "2008-01-01"), ])
sao_goncalo_2010 = with(sao_goncalo, sao_goncalo[(observation_date <= "2010-12-31" & observation_date >= "2010-01-01"), ])
sao_goncalo_2012 = with(sao_goncalo, sao_goncalo[(observation_date <= "2012-12-31" & observation_date >= "2012-01-01"), ])
sao_goncalo_2014 = with(sao_goncalo, sao_goncalo[(observation_date <= "2014-12-31" & observation_date >= "2014-01-01"), ])
# only contains 7 months block
sao_goncalo_2016 = with(sao_goncalo, sao_goncalo[(observation_date <= "2016-12-31" & observation_date >= "2016-01-01"), ])
ppPlot(sao_goncalo_2014, sao_goncalo_2016)

skim(sao_goncalo_2008)
skim(sao_goncalo_2010)
skim(sao_goncalo_2012)
skim(sao_goncalo_2014)
skim(sao_goncalo_2016)

par(mfrow=c(2,2)) # 2x2 block per graph
plot(type = "b", sao_goncalo_2008$observation_date, sao_goncalo_2008$air_temprature, xlab = "2008 12 month period" , ylab = "temperature in �C")
plot(type = "b", sao_goncalo_2008$observation_date, sao_goncalo_2008$precipitation_last_hr_mm, xlab = "2008 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2008$observation_date, sao_goncalo_2008$relative_humidity, xlab = "2008 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2008$observation_date, sao_goncalo_2008$solar_radiation, xlab = "2008 12 month period", ylab = "sunlight in  KJ/m2")


plot(type = "h", sao_goncalo_2010$observation_date, sao_goncalo_2010$air_temprature, xlab = "2010 12 month period", ylab = "temperature in �C")
plot(type = "b", sao_goncalo_2010$observation_date, sao_goncalo_2010$precipitation_last_hr_mm, xlab = "2010 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2010$observation_date, sao_goncalo_2010$relative_humidity, xlab = "2010 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2010$observation_date, sao_goncalo_2010$solar_radiation, xlab = "2010 12 month period", ylab = "sunlight in  KJ/m2")


plot(type = "h", sao_goncalo_2012$observation_date, sao_goncalo_2012$air_temprature, xlab = "2012 12 month period", ylab = "temperature in �C")
plot(type = "b", sao_goncalo_2012$observation_date, sao_goncalo_2012$precipitation_last_hr_mm, xlab = "2012 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2012$observation_date, sao_goncalo_2012$relative_humidity, xlab = "2012 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2012$observation_date, sao_goncalo_2012$solar_radiation, xlab = "2012 12 month period", ylab = "sunlight in  KJ/m2")


plot(type = "h", sao_goncalo_2014$observation_date, sao_goncalo_2014$air_temprature, xlab = "2014 12 month period", ylab = "temperature in �C")
plot(type = "b", sao_goncalo_2014$observation_date, sao_goncalo_2014$precipitation_last_hr_mm, xlab = "2014 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2014$observation_date, sao_goncalo_2014$relative_humidity, xlab = "2014 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2014$observation_date, sao_goncalo_2014$solar_radiation, xlab = "2014 12 month period", ylab = "sunlight in  KJ/m2")


plot(type = "h", sao_goncalo_2016$observation_date, sao_goncalo_2016$air_temprature, xlab = "2016 7 month period", ylab = "temperature in �C")
plot(type = "b", sao_goncalo_2016$observation_date, sao_goncalo_2016$precipitation_last_hr_mm, xlab = "2016 7 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2016$observation_date, sao_goncalo_2016$relative_humidity, xlab = "2016 7 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2016$observation_date, sao_goncalo_2016$solar_radiation, xlab = "2016 7 month period", ylab = "sunlight in  KJ/m2")


# quick inspection before forecasting
ggplot(data=sao_goncalo_2008, aes(y=solar_radiation, x=observation_date)) + geom_point() 
ggplot(data=sao_goncalo_2008, aes(y=solar_radiation, x=relative_humidity)) + geom_point()

ggplot(data=sao_goncalo_2010, aes(y=solar_radiation, x=observation_date)) + geom_point()
ggplot(data=sao_goncalo_2010, aes(y=solar_radiation, x=relative_humidity)) + geom_point()

ggplot(data=sao_goncalo_2012, aes(y=solar_radiation, x=observation_date)) + geom_point()
ggplot(data=sao_goncalo_2012, aes(y=solar_radiation, x=relative_humidity)) + geom_point()

# this forecast isnt very useful as it creates a flat line, similar results for other years
sao_goncalo_2008$precipitation_last_hr_mm %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()
sao_goncalo_2008$relative_humidity %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()
sao_goncalo_2008$solar_radiation %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()

summary(sao_goncalo$precipitation_last_hr_mm)
summary(sao_paulo$precipitation_last_hr_mm)


##########################################################################
# Assessing temperature changes in Sao Goncalo between 2008 and mid 2016 # 
##########################################################################

avg_temp_2008 = mean(sao_goncalo_2008$air_temprature)
temp_2008 = sapply(sao_goncalo_2008, max, na.rm = T)
highest_max_temp_2008 = getElement(temp_2008, "max_temp_hr")             
lowest_max_temp_2008 = getElement(temp_2008, "min_temp_hr")
# highest max temp is 31.2
# lowest max temp is 28.9
# avg is 24.68

avg_temp_2010 = mean(sao_goncalo_2010$air_temprature)
temp_2010 = sapply(sao_goncalo_2010, max, na.rm = T)
highest_max_temp_2010 = getElement(temp_2010, "max_temp_hr")
lowest_max_temp_2010 = getElement(temp_2010, "min_temp_hr")
# highest max temp is 33.5
# lowest max temp is 31.8
# avg is 24.6

avg_temp_2012 = mean(sao_goncalo_2012$air_temprature)
temp_2012 = sapply(sao_goncalo_2012, max, na.rm = T)
highest_max_temp_2012 = getElement(temp_2012, "max_temp_hr")
lowest_max_temp_2012 = getElement(temp_2012, "min_temp_hr")
# highest max temp is 34.6
# lowest max temp is 29
# avg is 23.45

avg_temp_2014 = mean(sao_goncalo_2014$air_temprature)
temp_2014 = sapply(sao_goncalo_2014, max, na.rm = T)
highest_max_temp_2014 = getElement(temp_2014, "max_temp_hr")
lowest_max_temp_2014 = getElement(temp_2014, "min_temp_hr")
# highest max temp is 35.6
# lowest max temp is 31.5
# avg is 24.48

avg_temp_2016 = mean(sao_goncalo_2016$air_temprature)
temp_2016 = sapply(sao_goncalo_2016, max, na.rm = T)
highest_max_temp_2016 = getElement(temp_2016, "max_temp_hr")
lowest_max_temp_2016 = getElement(temp_2016, "min_temp_hr")
# highest max temp is 35.5
# lowest max temp is 31.3
# avg is 25.58

avg_temps =  c(avg_temp_2008, avg_temp_2010, avg_temp_2012, avg_temp_2014, avg_temp_2016)
names(avg_temps) = c("2008", "2010", "2012", "2014", "2016")


highest_temps =  c(highest_max_temp_2008, highest_max_temp_2010, highest_max_temp_2012, highest_max_temp_2014, highest_max_temp_2016)
names(highest_temps) = c("2008", "2010", "2012", "2014", "2016")


lowest_temps = c(lowest_max_temp_2008, lowest_max_temp_2010, lowest_max_temp_2012, lowest_max_temp_2014, lowest_max_temp_2016)
names(lowest_temps) = c("2008", "2010", "2012", "2014", "2016")

# Graph it and compare changes

plot(type = "b", lowest_temps, xaxt="n", xlab = "Lowest Max Temperature Recorded Every 2 Years", ylab = "Degrees in Celsius", col="red")
axis(1, at = 1:5, labels = names(lowest_temps))


par(mfrow=c(1,2))
plot(type = "b", avg_temps, xaxt="n", xlab = "Average Temperature Recorded Every 2 Years", ylab = "Degrees in Celsius", col="orange")
axis(1, at = 1:5, labels = names(avg_temps))


plot(type = "b", highest_temps, xaxt="n", xlab = "Highest Max Temperature Recorded Every 2 Years", ylab = "Degrees in Celsius", col="blue")
axis(1, at = 1:5, labels = names(highest_temps))

sao_goncalo$max_temp_hr %>% na.interp() %>% ets() %>% forecast(h=39) %>% autoplot()
highest_temps %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()


#######################################################################
# Assessing rainfall changes in Sao Goncalo between 2008 and mid 2016 #
#######################################################################

sapply(df, max, na.rm = T)

avg_rainfall_2008 = mean(sao_goncalo_2008$precipitation_last_hr_mm)
highest_rainfall_2008 = getElement(temp_2008, "precipitation_last_hr_mm")             


avg_rainfall_2010 = mean(sao_goncalo_2010$precipitation_last_hr_mm)
highest_rainfall_2010 = getElement(temp_2010, "precipitation_last_hr_mm")


avg_rainfall_2012 = mean(sao_goncalo_2012$precipitation_last_hr_mm)
highest_rainfall_2012 = getElement(temp_2012, "precipitation_last_hr_mm")


avg_rainfall_2014 = mean(sao_goncalo_2014$precipitation_last_hr_mm)
highest_rainfall_2014 = getElement(temp_2014, "precipitation_last_hr_mm")


avg_rainfall_2016 = mean(sao_goncalo_2016$precipitation_last_hr_mm)
highest_rainfall_2016 = getElement(temp_2016, "precipitation_last_hr_mm")


avg_rainfall =  c(avg_rainfall_2008, avg_rainfall_2010, avg_rainfall_2012, avg_rainfall_2014, avg_rainfall_2016)
names(avg_rainfall) = c("2008", "2010", "2012", "2014", "2016")


highest_rainfall =  c(highest_rainfall_2008, highest_rainfall_2010, highest_rainfall_2012, highest_rainfall_2014, highest_rainfall_2016)
names(highest_rainfall) = c("2008", "2010", "2012", "2014", "2016")


par(mfrow=c(1,2))
plot(type = "b", avg_rainfall, xaxt="n", xlab = "Average Rainfall Recorded Every 2 Years", ylab = "Milliliters", col="orange")
axis(1, at = 1:5, labels = names(avg_rainfall))

plot(type = "b", highest_rainfall, xaxt="n", xlab = "Highest Rainfall Recorded Every 2 Years", ylab = "Milliliters", col="blue")
axis(1, at = 1:5, labels = names(highest_rainfall))

#######################################################################
# Assessing humidity changes in Sao Goncalo between 2008 and mid 2016 #
#######################################################################

sapply(df, max, na.rm = T)

avg_humidity_2008 = mean(sao_goncalo_2008$relative_humidity)
highest_humidity_2008 = getElement(temp_2008, "max_relative_humidity")             


avg_humidity_2010 = mean(sao_goncalo_2010$relative_humidity)
highest_humidity_2010 = getElement(temp_2010, "max_relative_humidity")


avg_humidity_2012 = mean(sao_goncalo_2012$relative_humidity)
highest_humidity_2012 = getElement(temp_2012, "max_relative_humidity")


avg_humidity_2014 = mean(sao_goncalo_2014$relative_humidity)
highest_humidity_2014 = getElement(temp_2014, "max_relative_humidity")


avg_humidity_2016 = mean(sao_goncalo_2016$relative_humidity)
highest_humidity_2016 = getElement(temp_2016, "max_relative_humidity")


avg_humidity =  c(avg_humidity_2008, avg_humidity_2010, avg_humidity_2012, avg_humidity_2014, avg_humidity_2016)
names(avg_humidity) = c("2008", "2010", "2012", "2014", "2016")


highest_humidity =  c(highest_humidity_2008, highest_humidity_2010, highest_humidity_2012, highest_humidity_2014, highest_humidity_2016)
names(highest_humidity) = c("2008", "2010", "2012", "2014", "2016")


par(mfrow=c(1,2))
plot(type = "b", avg_humidity, xaxt="n", xlab = "Average Humidity Recorded Every 2 Years", ylab = "Grams of Water Vapor per Kilogram", col="orange")
axis(1, at = 1:5, labels = names(avg_humidity))

plot(type = "b", highest_humidity, xaxt="n", xlab = "Highest Humidity Recorded Every 2 Years", ylab = "Grams of Water Vapor per Kilogram", col="blue")
axis(1, at = 1:5, labels = names(highest_humidity))

##########################################################
# Assessing humidity, rainfall and temperature in Brazil #
##########################################################

brazil_2008 = with(df, df[(observation_date <= "2008-12-31" & observation_date >= "2008-01-01"), ])
brazil_2010 = with(df, df[(observation_date <= "2010-12-31" & observation_date >= "2010-01-01"), ])
brazil_2012 = with(df, df[(observation_date <= "2012-12-31" & observation_date >= "2012-01-01"), ])
brazil_2014 = with(df, df[(observation_date <= "2014-12-31" & observation_date >= "2014-01-01"), ])
brazil_2016 = with(df, df[(observation_date <= "2016-12-31" & observation_date >= "2016-01-01"), ])


temp_brazil = sapply(df, max, na.rm = T)


avg_humidity_brazil = mean(df$relative_humidity)
highest_humidity_brazil = getElement(temp_brazil, "relative_humidity")
# avg is 83.7
# highest is 100


avg_temp_brazil = mean(df$max_temp_hr)
highest_temp_brazil = getElement(temp_brazil, "max_temp_hr")
# avg is 22
# highest is 42.4


avg_rainfall_brazil_2008 = mean(brazil_2008$precipitation_last_hr_mm)
highest_rainfall_brazil_2008 = getElement(temp_2008, "precipitation_last_hr_mm") 


avg_rainfall_brazil_2010 = mean(brazil_2010$precipitation_last_hr_mm)
highest_rainfall_brazil_2010 = getElement(temp_2010, "precipitation_last_hr_mm") 


avg_rainfall_brazil_2012 = mean(brazil_2012$precipitation_last_hr_mm)
highest_rainfall_brazil_2012 = getElement(temp_2012, "precipitation_last_hr_mm") 


avg_rainfall_brazil_2014 = mean(brazil_2014$precipitation_last_hr_mm)
highest_rainfall_brazil_2014 = getElement(temp_2014, "precipitation_last_hr_mm") 


avg_rainfall_brazil_2016 = mean(brazil_2016$precipitation_last_hr_mm)
highest_rainfall_brazil_2016 = getElement(temp_2016, "precipitation_last_hr_mm") 


avg_rainfall_brazil =  c(avg_rainfall_brazil_2008, avg_rainfall_brazil_2010, avg_rainfall_brazil_2012, avg_rainfall_brazil_2014, avg_rainfall_brazil_2016)
names(avg_rainfall_brazil) = c("2008", "2010", "2012", "2014", "2016")


highest_rainfall_brazil =  c(highest_rainfall_brazil_2008, highest_rainfall_brazil_2010, highest_rainfall_brazil_2012, highest_rainfall_brazil_2014, highest_rainfall_brazil_2016)
names(highest_rainfall_brazil) = c("2008", "2010", "2012", "2014", "2016")


par(mfrow=c(1,2))
plot(type = "b", avg_rainfall_brazil, xaxt="n", xlab = "Average Rainfall in Brazil Recorded Every 2 Years", ylab = "Milliliters", col="orange")
axis(1, at = 1:5, labels = names(avg_rainfall_brazil))

plot(type = "b", highest_rainfall_brazil, xaxt="n", xlab = "Highest Rainfall in Brazil Recorded Every 2 Years", ylab = "Milliliters", col="blue")
axis(1, at = 1:5, labels = names(highest_rainfall_brazil))



###################################
# Assessing rainfall in Sao Paulo #
###################################
sao_paulo_2008 = with(sao_paulo, sao_paulo[(observation_date <= "2008-12-31" & observation_date >= "2008-01-01"), ])
sao_paulo_2010 = with(sao_paulo, sao_paulo[(observation_date <= "2010-12-31" & observation_date >= "2010-01-01"), ])
sao_paulo_2012 = with(sao_paulo, sao_paulo[(observation_date <= "2012-12-31" & observation_date >= "2012-01-01"), ])
sao_paulo_2014 = with(sao_paulo, sao_paulo[(observation_date <= "2014-12-31" & observation_date >= "2014-01-01"), ])
sao_paulo_2016 = with(sao_paulo, sao_paulo[(observation_date <= "2016-12-31" & observation_date >= "2016-01-01"), ])

avg_rainfall_sao_paulo_2008 = mean(sao_paulo_2008$precipitation_last_hr_mm)
highest_rainfall_sao_paulo_2008 = getElement(temp_2008, "precipitation_last_hr_mm") 


avg_rainfall_sao_paulo_2010 = mean(sao_paulo_2010$precipitation_last_hr_mm)
highest_rainfall_sao_paulo_2010 = getElement(temp_2010, "precipitation_last_hr_mm") 


avg_rainfall_sao_paulo_2012 = mean(sao_paulo_2012$precipitation_last_hr_mm)
highest_rainfall_sao_paulo_2012 = getElement(temp_2012, "precipitation_last_hr_mm") 


avg_rainfall_sao_paulo_2014 = mean(sao_paulo_2014$precipitation_last_hr_mm)
highest_rainfall_sao_paulo_2014 = getElement(temp_2014, "precipitation_last_hr_mm") 


avg_rainfall_sao_paulo_2016 = mean(sao_paulo_2016$precipitation_last_hr_mm)
highest_rainfall_sao_paulo_2016 = getElement(temp_2016, "precipitation_last_hr_mm") 


avg_rainfall_sao_paulo =  c(avg_rainfall_sao_paulo_2008, avg_rainfall_sao_paulo_2010, avg_rainfall_sao_paulo_2012, avg_rainfall_sao_paulo_2014, avg_rainfall_sao_paulo_2016)
names(avg_rainfall_sao_paulo) = c("2008", "2010", "2012", "2014", "2016")


highest_rainfall_sao_paulo =  c(highest_rainfall_sao_paulo_2008, highest_rainfall_sao_paulo_2010, highest_rainfall_sao_paulo_2012, highest_rainfall_sao_paulo_2014, highest_rainfall_sao_paulo_2016)
names(highest_rainfall_sao_paulo) = c("2008", "2010", "2012", "2014", "2016")


par(mfrow=c(1,2))
plot(type = "b", avg_rainfall_sao_paulo, xaxt="n", xlab = "Average Rainfall in Sao Paulo Recorded Every 2 Years", ylab = "Milliliters", col="orange")
axis(1, at = 1:5, labels = names(avg_rainfall_sao_paulo))

plot(type = "b", highest_rainfall_sao_paulo, xaxt="n", xlab = "Highest Rainfall in Sao Paulo in Brazil Recorded Every 2 Years", ylab = "Milliliters", col="blue")
axis(1, at = 1:5, labels = names(highest_rainfall_sao_paulo))

