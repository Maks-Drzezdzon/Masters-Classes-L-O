library(tidyverse)
library(data.table)
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets
library(forecast)

df = read_feather('weather-data.feather')
sao_goncalo = as_tibble(filter(df, w_station_name == "SÃO GONÇALO"))
sao_paulo = as_tibble(filter(df, w_station_name == "São Paulo"))

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
# after further analysis there were so many 0 values in air temperature that it skewed the average to below 10 degrees
# the decision was made to treat this as noise and remove it from the data set
df$air_temprature[df$air_temprature < 1] = NA
df = na.omit(df)

####################
# data exploration #
####################
# this section focuses on exploring the data set
# and provide some insights for the written report

write_feather(df, 'weather-data.feather')
df = read_feather('weather-data.feather')
sao_goncalo = filter(df, w_station_name == "SÃO GONÇALO")


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
summary(sao_paulo$precipitation_last_hr_ml)
skim(sao_goncalo)

plot(sao_goncalo$observation_date_time, sao_goncalo$air_temprature)
hist( sao_goncalo$observation_date_time, sao_goncalo$air_temprature)

# this station has been in operation since 2008 more or less
# some data missing for 2009-2010, similar blip for 2011-2012
# there is also lots of 0 values during that time too
# there is very little data here, probably there was little rainfall

plot(sao_goncalo$observation_date_time, sao_goncalo$precipitation_last_hr_ml)
plot(sao_goncalo$observation_date_time, sao_goncalo$relative_humidity)
plot(sao_goncalo$observation_date_time, sao_goncalo$solar_radiation)

# 12 month blocks
sao_goncalo_2008 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2008-12-31" & observation_date_time >= "2008-01-01"), ])
sao_goncalo_2010 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2010-12-31" & observation_date_time >= "2010-01-01"), ])
sao_goncalo_2012 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2012-12-31" & observation_date_time >= "2012-01-01"), ])
sao_goncalo_2014 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2014-12-31" & observation_date_time >= "2014-01-01"), ])
# only contains 7 months block
sao_goncalo_2016 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2016-12-31" & observation_date_time >= "2016-01-01"), ])

skim(sao_goncalo_2008)
skim(sao_goncalo_2010)
skim(sao_goncalo_2012)
skim(sao_goncalo_2014)
skim(sao_goncalo_2016)

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


plot(type = "h", sao_goncalo_2014$observation_date_time, sao_goncalo_2014$dew_temp, xlab = "2014 12 month period", ylab = "temperature in °C")
plot(type = "b", sao_goncalo_2014$observation_date_time, sao_goncalo_2014$precipitation_last_hr_ml, xlab = "2014 12 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2014$observation_date_time, sao_goncalo_2014$relative_humidity, xlab = "2014 12 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2014$observation_date_time, sao_goncalo_2014$solar_radiation, xlab = "2014 12 month period", ylab = "sunlight in  KJ/m2")


plot(type = "h", sao_goncalo_2016$observation_date_time, sao_goncalo_2016$dew_temp, xlab = "2016 7 month period", ylab = "temperature in °C")
plot(type = "b", sao_goncalo_2016$observation_date_time, sao_goncalo_2016$precipitation_last_hr_ml, xlab = "2016 7 month period", ylab = "rain fall in millimetres ")
plot(type = "h", sao_goncalo_2016$observation_date_time, sao_goncalo_2016$relative_humidity, xlab = "2016 7 month period", ylab = "humidity as % out of 100")
plot(type = "l", sao_goncalo_2016$observation_date_time, sao_goncalo_2016$solar_radiation, xlab = "2016 7 month period", ylab = "sunlight in  KJ/m2")


# quick inspection before forecasting
ggplot(data=sao_goncalo_2008, aes(y=solar_radiation, x=observation_date_time)) + geom_point() 
ggplot(data=sao_goncalo_2008, aes(y=solar_radiation, x=relative_humidity)) + geom_point()

ggplot(data=sao_goncalo_2010, aes(y=solar_radiation, x=observation_date_time)) + geom_point()
ggplot(data=sao_goncalo_2010, aes(y=solar_radiation, x=relative_humidity)) + geom_point()

ggplot(data=sao_goncalo_2012, aes(y=solar_radiation, x=observation_date_time)) + geom_point()
ggplot(data=sao_goncalo_2012, aes(y=solar_radiation, x=relative_humidity)) + geom_point()

# this forecast isnt very useful as it creates a flat line, similar results for other years
sao_goncalo_2008$precipitation_last_hr_ml %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()
sao_goncalo_2008$relative_humidity %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()
sao_goncalo_2008$solar_radiation %>% na.interp() %>% ets() %>% forecast(h=30) %>% autoplot()


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

avg_rainfall_2008 = mean(sao_goncalo_2008$precipitation_last_hr_ml)
highest_rainfall_2008 = getElement(temp_2008, "precipitation_last_hr_ml")             


avg_rainfall_2010 = mean(sao_goncalo_2010$precipitation_last_hr_ml)
highest_rainfall_2010 = getElement(temp_2010, "precipitation_last_hr_ml")


avg_rainfall_2012 = mean(sao_goncalo_2012$precipitation_last_hr_ml)
highest_rainfall_2012 = getElement(temp_2012, "precipitation_last_hr_ml")


avg_rainfall_2014 = mean(sao_goncalo_2014$precipitation_last_hr_ml)
highest_rainfall_2014 = getElement(temp_2014, "precipitation_last_hr_ml")


avg_rainfall_2016 = mean(sao_goncalo_2016$precipitation_last_hr_ml)
highest_rainfall_2016 = getElement(temp_2016, "precipitation_last_hr_ml")


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

brazil_2008 = with(df, df[(observation_date_time <= "2008-12-31" & observation_date_time >= "2008-01-01"), ])
brazil_2010 = with(df, df[(observation_date_time <= "2010-12-31" & observation_date_time >= "2010-01-01"), ])
brazil_2012 = with(df, df[(observation_date_time <= "2012-12-31" & observation_date_time >= "2012-01-01"), ])
brazil_2014 = with(df, df[(observation_date_time <= "2014-12-31" & observation_date_time >= "2014-01-01"), ])
brazil_2016 = with(df, df[(observation_date_time <= "2016-12-31" & observation_date_time >= "2016-01-01"), ])


temp_brazil = sapply(df, max, na.rm = T)


avg_humidity_brazil = mean(df$relative_humidity)
highest_humidity_brazil = getElement(temp_brazil, "relative_humidity")
# avg is 83.7
# highest is 100


avg_temp_brazil = mean(df$max_temp_hr)
highest_temp_brazil = getElement(temp_brazil, "max_temp_hr")
# avg is 22
# highest is 42.4


avg_rainfall_brazil_2008 = mean(brazil_2008$precipitation_last_hr_ml)
highest_rainfall_brazil_2008 = getElement(temp_2008, "precipitation_last_hr_ml") 


avg_rainfall_brazil_2010 = mean(brazil_2010$precipitation_last_hr_ml)
highest_rainfall_brazil_2010 = getElement(temp_2010, "precipitation_last_hr_ml") 


avg_rainfall_brazil_2012 = mean(brazil_2012$precipitation_last_hr_ml)
highest_rainfall_brazil_2012 = getElement(temp_2012, "precipitation_last_hr_ml") 


avg_rainfall_brazil_2014 = mean(brazil_2014$precipitation_last_hr_ml)
highest_rainfall_brazil_2014 = getElement(temp_2014, "precipitation_last_hr_ml") 


avg_rainfall_brazil_2016 = mean(brazil_2016$precipitation_last_hr_ml)
highest_rainfall_brazil_2016 = getElement(temp_2016, "precipitation_last_hr_ml") 


avg_rainfall_brazil =  c(avg_rainfall_brazil_2008, avg_rainfall_brazil_2010, avg_rainfall_brazil_2012, avg_rainfall_brazil_2014, avg_rainfall_brazil_2016)
names(avg_rainfall_brazil) = c("2008", "2010", "2012", "2014", "2016")


highest_rainfall_brazil =  c(highest_rainfall_brazil_2008, highest_rainfall_brazil_2010, highest_rainfall_brazil_2012, highest_rainfall_brazil_2014, highest_rainfall_brazil_2016)
names(highest_rainfall_brazil) = c("2008", "2010", "2012", "2014", "2016")


par(mfrow=c(1,2))
plot(type = "b", avg_rainfall_brazil, xaxt="n", xlab = "Average Rainfall in Brazil Recorded Every 2 Years", ylab = "Milliliters", col="orange")
axis(1, at = 1:5, labels = names(avg_rainfall_brazil))

plot(type = "b", highest_rainfall_brazil, xaxt="n", xlab = "Highest Rainfall in Brazil Recorded Every 2 Years", ylab = "Milliliters", col="blue")
axis(1, at = 1:5, labels = names(highest_rainfall_brazil))



###################################################
# Assessing rainfall and temperature in Sao Paulo #
###################################################
sao_paulo_2008 = with(sao_paulo, sao_paulo[(observation_date_time <= "2008-12-31" & observation_date_time >= "2008-01-01"), ])
sao_paulo_2010 = with(sao_paulo, sao_paulo[(observation_date_time <= "2010-12-31" & observation_date_time >= "2010-01-01"), ])
sao_paulo_2012 = with(sao_paulo, sao_paulo[(observation_date_time <= "2012-12-31" & observation_date_time >= "2012-01-01"), ])
sao_paulo_2014 = with(sao_paulo, sao_paulo[(observation_date_time <= "2014-12-31" & observation_date_time >= "2014-01-01"), ])
sao_paulo_2016 = with(sao_paulo, sao_paulo[(observation_date_time <= "2016-12-31" & observation_date_time >= "2016-01-01"), ])

avg_rainfall_sao_paulo_2008 = mean(sao_paulo_2008$precipitation_last_hr_ml)
highest_rainfall_sao_paulo_2008 = getElement(temp_2008, "precipitation_last_hr_ml") 


avg_rainfall_sao_paulo_2010 = mean(sao_paulo_2010$precipitation_last_hr_ml)
highest_rainfall_sao_paulo_2010 = getElement(temp_2010, "precipitation_last_hr_ml") 


avg_rainfall_sao_paulo_2012 = mean(sao_paulo_2012$precipitation_last_hr_ml)
highest_rainfall_sao_paulo_2012 = getElement(temp_2012, "precipitation_last_hr_ml") 


avg_rainfall_sao_paulo_2014 = mean(sao_paulo_2014$precipitation_last_hr_ml)
highest_rainfall_sao_paulo_2014 = getElement(temp_2014, "precipitation_last_hr_ml") 


avg_rainfall_sao_paulo_2016 = mean(sao_paulo_2016$precipitation_last_hr_ml)
highest_rainfall_sao_paulo_2016 = getElement(temp_2016, "precipitation_last_hr_ml") 


avg_rainfall_sao_paulo =  c(avg_rainfall_sao_paulo_2008, avg_rainfall_sao_paulo_2010, avg_rainfall_sao_paulo_2012, avg_rainfall_sao_paulo_2014, avg_rainfall_sao_paulo_2016)
names(avg_rainfall_sao_paulo) = c("2008", "2010", "2012", "2014", "2016")


highest_rainfall_sao_paulo =  c(highest_rainfall_sao_paulo_2008, highest_rainfall_sao_paulo_2010, highest_rainfall_sao_paulo_2012, highest_rainfall_sao_paulo_2014, highest_rainfall_sao_paulo_2016)
names(highest_rainfall_sao_paulo) = c("2008", "2010", "2012", "2014", "2016")


par(mfrow=c(1,2))
plot(type = "b", avg_rainfall_sao_paulo, xaxt="n", xlab = "Average Rainfall in Sao Paulo Recorded Every 2 Years", ylab = "Milliliters", col="orange")
axis(1, at = 1:5, labels = names(avg_rainfall_sao_paulo))

plot(type = "b", highest_rainfall_sao_paulo, xaxt="n", xlab = "Highest Rainfall in Sao Paulo in Brazil Recorded Every 2 Years", ylab = "Milliliters", col="blue")
axis(1, at = 1:5, labels = names(highest_rainfall_sao_paulo))

