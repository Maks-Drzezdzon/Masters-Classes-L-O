library(dplyr)
library(tidyverse)
library(data.table)
library(feather)
library(lubridate)

# file is small enough to hold in memory ~2gigs
# https://www.kaggle.com/PROPPG-PPG/hourly-weather-surface-brazil-southeast-region
df = read_csv('weather-data.csv')
# inspect df data types and cols
spec(df)

# rename cols to be more descriptive 
new_names = 
df = df %>% setnames( 
                      old = c(colnames(df)), 
                      new = c( "ID", "w_station_name", "elevation", "lat", "long", 
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

##############
# Start Here #
##############

df = read_feather('weather-data.feather')
head(df)
colnames(df)
# need to fix time formats
typeof(df$observation_date) # integer
typeof(df$observation_date_time) # double
# find empty vals count for each col
# (tidyverse function)
map(df , ~sum(is.na(.)))

# construct timedates and fill out any gaps then  drop them as they arent needed
df %>% mutate(observation_date = make_date(year, month, day))
df %>% mutate(observation_date_time = make_datetime(year, month, day, hour)) 
# drop cols in c()
df = df[,!names(df) %in% c("year", "month", "day", "hour")]
head(df)
colnames(df)
# cut off 300 Mb of data
write_feather(df, 'weather-data.feather')


sao_goncalo = where(df, city == 'SÃO GONÇALO')
sao_goncalo


head(d)
select(d, city)



