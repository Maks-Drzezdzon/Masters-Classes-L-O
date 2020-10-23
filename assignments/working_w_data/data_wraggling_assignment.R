library(dplyr)
library(tidyverse)
library(data.table)

# file is small enough to hold in memory ~2gigs
# use read_csv for optimized load speed
df = read_csv('weather-data.csv')
# inspect df data types and cols
spec(df)
# rename cols to be more descriptive 
# ID = wsid, w_station_name = wsnm,
names_old = c(colnames(df))
names_new = c("ID", "w_station_name", "elevation", "lat", "long", "station_num", "city", "province", "observation_date_time", "observation_date", "year", "month", "day", "hour", "precipitation_last_hr_ml", "air_pressure_hr_hPa", "max_air_pressure_hr_hPa", "min_air_pressure_hr_hPa", "solar_radiation", "air_temprature", "dew_temp", "max_temp_hr", "max_dew_temp", "min_temp_hr", "min_dew_temp", "relative_humidity", "max_relative_humidity", "min_relative_humidity", "wind_speed", "wind_direction_rdegrees", "wind_gust_mps"  )

df = df %>% setnames( old = names_old, new = names_new)

colnames(df)

# inspect unique weather station names, 122 as the file suggests
unique(df$wsnm , incomparables = FALSE)

sao_goncalo = where(df, city == 'SÃO GONÇALO')
sao_goncalo


head(d)
select(d, city)
