library(nycflights13)
library(dplyr)
library(ggplot2)

# Q1 How many fights that flew to Houston (airport code 'IAH' or 'HOU') had an arrival delay of two or more hours?

houston_2hdelay <- filter(flights, dest == 'IAH' | dest == 'HOU', arr_delay > 120)
count(houston_2hdelay)

# Q2 How many fights were delayed by at least an hour, but made up over 30 minutes in flight?

delay_one_half <- filter(flights, dep_delay >= 60, arr_delay <= dep_delay - 30)
count(delay_one_half)

# Q3 How could you use arrange() to sort all missing values to the start? (Hint: use is.na())

arrange(flights,desc(is.na(dep_time)))

# Q4 Which flight travels the longest distance?

longest <- filter(flights,distance==max(distance))
distinct(longest,flight)

# Q5 Find a concise way to select the columns that have 'time' in their name.

time_columns <- select(flights,contains("time"))

# Q6 Look at the number of cancelled flights per day. Is there a pattern?

cancelled <- mutate(flights, cancelled = (is.na(arr_delay) | is.na(dep_delay)))
cancelled_by_day <- group_by(cancelled,year,month,day)
cancelled_per_day <- summarise(cancelled_by_day,cancelled_num = sum(cancelled),flights_num = n())

ggplot(cancelled_per_day) + geom_point(aes(x = flights_num, y = cancelled_num)) 

# Q7 Which carrier has the worst delays?

carriers <- group_by(flights,carrier)
carrier_delays <- summarise(carriers,arr_delay = mean(arr_delay, na.rm = TRUE))
worst_delays <- arrange(carrier_delays,desc(arr_delay))
filter(airlines, carrier == worst_delays$carrier[1])

# Q8 Filter flights to only show flights with planes that have flown at least 100 flights.

plane_flights <- filter(flights,!is.na(tailnum))
planes <- group_by(plane_flights,tailnum)
planes_100 <- filter(count(planes), n >= 100)

# Q9 What time of day should you fly if you want to avoid delays as much as possible?

flights_by_hour <- group_by(flights,hour)
not_cancelled_by_hour <- filter(flights_by_hour,!is.na(dep_delay))
delays_by_hour <- summarise(not_cancelled_by_hour, delay = mean(dep_delay > 0 , na.rm = T))
ggplot(delays_by_hour,aes(hour, delay, fill = delay)) + geom_col() 

# Q10 Add the location of the origin and destination (i.e. the lat and lon) to flights.

airport_locations <- airports %>%
  select(faa, lat, lon)
flights %>%
  select(year:day, hour, origin, dest) %>%
  left_join(
    airport_locations,
    by = c("origin" = "faa")
  ) %>%
  left_join(
    airport_locations,
    by = c("dest" = "faa"),
    suffix = c("_origin", "_dest")
  )