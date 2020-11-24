library(tidyverse)
library(lubridate)
library(data.table)

df = read_csv("dataset.csv")
df = read_csv("dataset-updated.csv")

# ToDo's

# 1) Clean the Data Set
# 2) relevant summary statistics, single visualisation that 
# captures the relationship between at least 3 of the original variables
# 3) Focus on a subset of the data and create 3 derived variables 
# for the purposes of answering a single question of interest.

# 1.) 1 file containing all code written during exam
# 2.) 1 much shorter file containing only the code to perform the 3 specific tasks.
# https://www.statmethods.net/graphs/scatterplot.html
############
# Cleaning #
############
colnames(df)

# rename 
df = df %>% setnames(
  old = c(colnames(df)),
  new = c("season_year", "Rk", "player_name", "position",
          "player_age", "team_name", "games_played", "games_started",
          "minutes_played_per_game", "successful_field_goals_per_game", 
          
          "field_goals_attempts_per_game", "field_goals_successrate_for_season",
          "three_pointers_per_game", "three_pointer_attempts_per_game",
          "three_pointer_successrate",
          "two_pointers_per_game", "two_pointer_attempts_per_game",
          "two_pointer_successrate",
          
          "effective_field_goal_percent_per_season", "successful_free_throws_per_game",
          "free_throw_attempts_per_game", "successful_free_throw_percentage_per_season",
          "offensive_rebounds_per_game", "defensive_rebounds_per_game",
          
          "total_rebounds_per_game", "assists_per_game",
          "steals_per_game", "blocks_per_game",
          "turnovers_per_game", "personal_fouls_per_game",
          "points_per_game")
)

# drop col and drop index col
df = df[,!names(df) %in% c("Rk", "X1", "drop_me")]
# hot swap
temp = df
# reload
df = temp

# didnt have time to finish this
# df$three_pointers_per_game/df$three_pointer_attempts_per_game
# df$three_pointer_successrate[is.na(df$three_pointer_successrate)] = df$three_pointers_per_game/df$three_pointer_attempts_per_game
# df$two_pointer_successrate[is.na(df$two_pointer_successrate)] = df$two_pointers_per_game/df$two_pointer_attempts_per_game

# create new cols
df=separate(df, season_year, sep = "-", into = c("season_start_year","season_end_year"))

# ToDo didnt have time to finish and fix names
# df=separate(df, player_name, sep = "\\", into = c("player_name","drop_me"))

df
# change to date
df = df %>% mutate(season_start_year = make_date(season_start_year))
df = df %>% mutate(season_end_year = make_date(season_end_year))
# save just incase
write.csv(df, "dataset-updated.csv", row.names = F)

map(df , ~sum(is.na(.)))
df = na.omit(df)
colnames(df)
###############
# Exploration #
###############

correlation_matrix_data = df[,!names(df) %in% c("season_start_year", "season_end_year", "player_name", "position", "team_name")]
correlation_matrix_data = cor(correlation_matrix_data)
head(correlation_matrix_data)
df$two_pointer_successrate
head(df)
head(df$three_pointer_successrate)
tail(df)
max(df$successful_field_goals_per_game)
max(df$minutes_played_per_game)
df$player_name
summary(df)
glimpse(df)
fivenum(df)
plot(df$player_age)
qqplot(df$player_age)
boxplot(df$player_age)

help(heatmap)
heatmap(correlation_matrix_data, na.rm = T, main = "MBA correlation heat map")

############
# Analysis #
############

# subset data and create 3 derived variables
mba_2019_season = with(df, df[(season_start_year <= "2018-01-01" & season_end_year >= "2019-01-01"), ])
mba_2019_season = df[,!names(mba_2019_season) %in% c("Rk", "position",
                                                     "team_name","successful_field_goals_per_game", 
                                                     
                                                     "field_goals_attempts_per_game", "field_goals_successrate_for_season",
                                                     "three_pointers_per_game", "three_pointer_attempts_per_game",
                                                     "three_pointer_successrate",
                                                     "two_pointers_per_game", "two_pointer_attempts_per_game",
                                                     "two_pointer_successrate",
                                                     
                                                     "effective_field_goal_percent_per_season", "successful_free_throws_per_game",
                                                     "free_throw_attempts_per_game", "successful_free_throw_percentage_per_season",
                                                     "offensive_rebounds_per_game", "defensive_rebounds_per_game")]

mba_2019_season
colnames(mba_2019_season)
head(mba_2019_season)

# the question is, can you predict or forecast the players career by their activity 
# how often do they get to play, how often are they allowed to start from the beginning etc

# assumption is that these dont have to be saved in the dataset
# if they were then one can use cbind(colname, another_colname) etc

# the higher the decimal the better the player yield is, the earlier they are in their career as younger players tend to get more field time
game_activity = mba_2019_season$games_played/mba_2019_season$player_age

# the lower the number the better, as the player started in more games
start_game_chances = mba_2019_season$games_played - mba_2019_season$games_started

# the higher the score the better a player defends/pushes the other team back
game_effectiveness_participation = mba_2019_season$steals_per_game + mba_2019_season$assists_per_game + mba_2019_season$blocks_per_game


# matrix = cor(c(x = game_activity, start_game_chances, game_effectiveness_participation, y = game_activity, start_game_chances, game_effectiveness_participation)))

write.csv(mba_2019_season, "final-dataset.csv", row.names = F)



