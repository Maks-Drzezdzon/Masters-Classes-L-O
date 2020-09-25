library("ggplot2")


# these values are taken out of die
# must set replace = TRUE for them to be... replaced
 roll = function(){
   dice = 1:6
   sample(die, size = 1, replace = TRUE)
 }
 
 roll_twice = function(){
   replicate(2 , roll())
 }
 
roll()
roll_twice()
 
