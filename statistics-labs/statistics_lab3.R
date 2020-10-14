
survey = read.table("stats_lab3/survey.dat",sep=";",header=TRUE)

cor.test(data, data, method = "spearman")

# ToDo for portfolio
# skewness and kurtosis z-values
# --- -/+ 1.96 

# shapiro-wilk test p-value
# above 0.05

# visual tests
# histogram, normal Q-Q plots and box plots
# these should show visually show that data is, well, normal
