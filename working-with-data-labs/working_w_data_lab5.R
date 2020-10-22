library(dplyr)
library(ggplot2)
library(foreign)

births = read.csv('births.csv')
baby_names = data.frame(read.csv('bnames.csv'))

df_baby_names = data.frame(baby_names)

filter(baby_names, name == 'John')
select(baby_names, name, year, sex)
head(arrange(baby_names, name, year))
head(summarise(baby_names, name, year))

inner_join(baby_names,births, by = c('sex', 'year'))

# group by name
# namesBirth = group_by(births, name)
# summarise ( births , total = sum( total ) )

# look over some joins on dplyr
# test = read.dbf('test/stl_parcels_2002.dbf')
# head(test)
