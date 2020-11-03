library(tidyverse)
library(data.table)
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets

df = read_feather('weather-data.feather')
sao_goncalo = filter(df, w_station_name == "SÃO GONÇALO")




###############
# ^^ LOAD  ^^ #
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
# inspect df data types and cols
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
df = read_feather('weather-data.feather')
sao_goncalo = filter(df, w_station_name == "SÃO GONÇALO")



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
glimpse(sao_goncalo)
# exploring other options
str(sao_goncalo)
summary(df)
summary(sao_goncalo$observation_date)

# Look over this
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


sao_goncalo_2008 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2008-12-31"), ])
sao_goncalo_2009 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2012-12-31" & observation_date_time >= "2012-01-01"), ])
sao_goncalo_2010 = with(sao_goncalo, sao_goncalo[(observation_date_time <= "2010-12-31" & observation_date_time >= "2010-01-01"), ])

sao_goncalo2 = na.omit(sao_goncalo)
sao_goncalo2 = with(sao_goncalo2, sao_goncalo2[(observation_date_time <= "2008-12-31"), ])

plot(sao_goncalo2$observation_date_time, sao_goncalo2$precipitation_last_hr_ml)
plot(sao_goncalo2$observation_date_time, sao_goncalo2$relative_humidity)
plot(sao_goncalo2$observation_date_time, sao_goncalo2$solar_radiation)


ggplot(sao_goncalo2, aes(observation_date_time, precipitation_last_hr_ml)) +
  ggtitle("title")

ggplot(sao_goncalo_2008) + geom_histogram(bins = 12, aes(x=observation_date_time)) # missing
ggplot(sao_goncalo_2009) + geom_histogram(bins = 12, aes(x=observation_date_time)) # missing
ggplot(sao_goncalo_2010) + geom_histogram(bins = 12, aes(x=observation_date_time)) # good year

sao_goncalo_2010 %>% group_by("observation_date_time")

ggplot(data = sao_goncalo_2010) +
  geom_sf() +
  xlab("Longitude") + ylab("Latitude") +
  ggtitle("World map", subtitle = paste0("(", length(unique(sao_goncalo_2010$w_station_name)), " w_station_name)"))

# use lat and log values to create map graph
# find most rainy months in 2010
# check lat long values with lat long of city
# Air pressure and wind analysis
# graph all stations, compare two that are far apart or close to each other ??
# move to visualization 



######################
# data visualization #
######################
# this section focuses on generating visualizations
# for the report along with exploring different methods 
# of doing so







