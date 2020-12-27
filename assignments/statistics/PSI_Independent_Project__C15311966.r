library(tidyverse)
library(readxl) # read xlsx
library(feather) # file format lib
library(lubridate) # date transformation 
library(reticulate) # embed python inside R code
library(skimr) # summary statistics for larger data sets
library(forecast)

# Maksymilian Drzezdzon

####################
# Data Exploration # 
####################

# loading data
df = read_excel('idepen_proj_stats.xlsx')
# basic exploration
head(df)
summary(df)
str(df)
colnames(df)
# how many missing values are in each col
map(df , ~sum(is.na(.)))

# looking at cols with potential problems 
unique(df$PHONE)
unique(df$...10)
unique(df$SISBEN)
unique(df$JOB)
unique(df$UNIVERSITY)
unique(df$EDU_FATHER)

# column is completely empty and serves no purpose 
df = df[,!names(df) %in% c("...10")]


#################
# Data Cleaning # 
#################















"""
Variable    	Full name	    Mean	Standard Deviation	Max	Min
MAT_S11	      Mathematics	    64.32	11.87	100	26
CR_S11	      Critical Reading	    60.78	10.03	100	24
CC_S11	      Citizen Competencies S11	    60.71	10.12	100	0
BIO_S11	      Biology	63.95	11.16	100	11
ENG_S11	      English	61.80	14.30	100	26
QR_PRO	      Quantitative Reasoning	77.42	22.67	100	1
CR_PRO	      Critical Reading	62.20	27.67	100	1
CC_PRO	      Citizen Competencies SPRO	59.19	28.99	100	1
ENG_PRO	      English	67.50	25.49	100	1
WC_PRO	      Written Communication	53.70	30.00	100	0
FEP_PRO	      Formulation of Engineering Projects	145.48	40.12	300	1
G_SC	        Global Score	162.71	23.11	247	37
PERCENTILE	  Percentile	68.45	25.87	100	1
2ND_DECILE	  Second Decile	3.89	1.25	5	1
QUARTILE	    Quartile	3.19	0.98	4	1
SEL	          Socioeconomic Level	2.60	1.11	4	1
SEL_IHE	      The Institution of Higher Education	2.41	0.93	4	1
"""


