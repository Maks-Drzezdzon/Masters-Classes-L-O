
survey = read.table("stats_lab3/survey.dat",sep=";",header=TRUE)

cor.test(data, data, method = "spearman")

# ToDo for portfolio
# parametric tests
# skewness and kurtosis z-values
# the closer to 0 the better

# skewness / std error
# kurtosis / std error
# should be between -/+ 1.96 

# shapiro-wilk test p-value
# null-H is that the data is normally distributed 
# so above 0.05, data is approx distributed
# it is rejected if it is below 0.05, is not approx distributed

# visual tests
# histogram, normal Q-Q plots and box plots
# these should show visually show that data is, well, normal
