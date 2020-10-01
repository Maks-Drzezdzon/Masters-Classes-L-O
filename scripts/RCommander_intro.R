
data(Salaries, package="carData")


indexplot(Adler[,'rating', drop=FALSE], type='h', id.method='y', id.n=2)
library(abind, pos=17)
library(e1071, pos=18)
numSummary(Adler[,"rating", drop=FALSE], statistics=c("mean", "sd", "IQR", 
  "quantiles"), quantiles=c(0,.25,.5,.75,1))
data(Salaries, package="carData")
numSummary(Salaries[,"salary", drop=FALSE], statistics=c("mean", "sd", 
  "IQR", "quantiles"), quantiles=c(0,.25,.5,.75,1))
numSummary(Salaries[,"yrs.service", drop=FALSE], statistics=c("mean", "sd", 
  "IQR", "quantiles"), quantiles=c(0,.25,.5,.75,1))
with(Salaries, Hist(salary, scale="frequency", breaks="Sturges", 
  col="darkgray"))
with(Salaries, Hist(salary, groups=sex, scale="frequency", breaks="Sturges",
   col="darkgray"))
local({
  .Table <- with(Salaries, table(discipline))
  cat("\ncounts:\n")
  print(.Table)
  cat("\npercentages:\n")
  print(round(100*.Table/sum(.Table), 2))
})
local({
  .Table <- xtabs(~discipline+sex, data=Salaries)
  cat("\nFrequency table:\n")
  print(.Table)
  .Test <- chisq.test(.Table, correct=FALSE)
  print(.Test)
})
densityPlot( ~ salary, data=Salaries, bw=bw.SJ, adjust=1, kernel=dnorm, 
  method="adaptive")

