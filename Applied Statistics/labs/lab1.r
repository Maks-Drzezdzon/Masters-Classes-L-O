library(pastecs) #For creating descriptive statistic summaries
library(ggplot2) #For creating histograms with more detail than plot
library(psych) # Some useful descriptive functions
library(semTools) #For skewness and kurtosis
library(FSA) #For percentage
library(car) # For Levene's test for homogeneity of variance 
library(effectsize) #To calculate effect size for t-test

setwd("~/GitHub/Masters-Classes-L-O/Applied Statistics/data_stats")
getwd()
data = read.csv("optometry_SE_AC.csv")
colnames(data)[1] = "mean sphere refractive errors (D)"
colnames(data)[2] = "anterior chamber depth (mm)"
head(data)

# (5) Get a report-ready scatter plot of mean spherical error (on the vertical axis) against  anterior chamber depth - include nice plot and axis labels etc.
scatter_plot = ggplot(data, aes(x=`mean sphere refractive errors (D)`,
                                y=`anterior chamber depth (mm)`, 
                                color = 'mean sphere refractive errors (D)', show.legend = T)) + geom_point(size=2)
scatter_plot

# (6) Fit a simple linear regression model to these data with spherical error as the response. What do you conclude?
# lin_reg = (slope) * variable_name + (intercept)
lin_reg = lm(`anterior chamber depth (mm)`~`mean sphere refractive errors (D)`, data=data)
lin_reg
summary(lin_reg)

# (7) Plot the simple ls line on your scatter plot and include a suitable descriptive legend for this line.
scatter_plot_ls = scatter_plot + geom_smooth(method = "lm", se = FALSE)
scatter_plot_ls

# (8) Fit a quadratic curved line as well - is there any evidence that we need a curved line here?
scatter_plot_qc = scatter_plot + 
  geom_point(size=2) + 
  stat_smooth(method = "lm", formula = y ~ x + I(x^2), size = 1)
scatter_plot_qc
  
# (9) In any case, plot the curved line on the scatter plot and amend the legend accordingly.
# done

# (10) Save the plot as a .png image or .jpeg image for inclusion in a report.
# done

