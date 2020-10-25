library(dplyr)
library(tidyverse)
library(data.table)
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets

df = read_feather('weather-data.feather')
sao_goncalo = filter(df, w_station_name == "SÃO GONÇALO")




#################
# ^^ LOAD ME ^^ #
#################




# main repo # https://github.com/Maks-Drzezdzon/Masters-Classes-L-O/tree/master/assignments/working_w_data
# file is small enough to hold in memory ~2gigs
# https://www.kaggle.com/PROPPG-PPG/hourly-weather-surface-brazil-southeast-region




##########################
# initial data wrangling #
##########################
# this section focuses on wrangling a csv file
# to produce a feather file used in further sections

df = read_csv('weather-data.csv')
# inspect df data types and cols
spec(df)

# rename cols to be more descriptive 
new_names = 
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
unique(df$wsnm , incomparables = FALSE)
# saving file to feather format as its has faster I/O 
# and is supported by both python and r
# from here on out the feather file will be used instead
# drawback is that its slightly larger than the original file
# HDF5 would be better for a mix of I/O and size optimization
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
# update feather file
# cut off 300 Mb of data
write_feather(df, 'weather-data.feather')




####################
# data exploration #
####################
# this section focuses on exploring the data set
# and provide some insights for the written report



# find empty values count for each col
# (tidyverse function)
# missing data
map(df , ~sum(is.na(.)))
# df[row,col]
# explore data of one city 
View(sao_goncalo)
# dyplyr function, data set is too big for table()
glimpse(df)
# exploring other options
str(df)
summary(df)
summary(sao_goncalo)

# Look over this
skim(sao_goncalo)
# all data
# plot(df$observation_date_time, df$air_temprature)
# ToDo look over plots
# https://www.kaggle.com/sanjayroberts1/exploratory-data-analysis-and-clean-up

plot(sao_goncalo$observation_date_time, sao_goncalo$air_temprature)
hist( sao_goncalo$observation_date_time, sao_goncalo$air_temprature)

# this station has been in operation since 2008 more or less
# some data missing for 2009-2010, similar blip for 2011-2012
# there is also lots of 0 values during that time too
plot(sao_goncalo$observation_date_time, sao_goncalo$precipitation_last_hr_ml)
# there is very little data here meaning there is little rainfall
plot(sao_goncalo$observation_date_time, sao_goncalo$relative_humidity)
# another example of missing data in 2009-2010 and 2011-2012
plot(sao_goncalo$observation_date_time, sao_goncalo$solar_radiation)
# another example of missing data in 2009-2010 and 2011-2012

identify(sao_goncalo$observation_date_time, sao_goncalo$air_temprature, lables = paste(as.character(sao_goncalo$observation_date_time )))


plot(sao_goncalo$observation_date_time, )





######################
# data visualization #
######################
# this section focuses on generating visualizations
# for the report along with exploring different methods 
# of doing so







