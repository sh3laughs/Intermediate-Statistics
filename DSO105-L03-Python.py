# %%
# DSO105 - Intermediate Statistics
    # Lesson 3 - Advanced Chi-Squares

# Page 3 - One Proportion Testing in Python

# Import packages
import pandas as pd
import numpy as np
from statsmodels.stats.proportion import proportions_ztest

# %%
# One proportion test
count = 15
sample = 43
value = 0.5

stat, pval = proportions_ztest(count, sample, value)

print(stat, pval)

# %%
# -2.079806538622099 0.03754328113448803
    # Note: Because this p value is under 0.05, this determined that 
    # this count is a significantly different proportion than 50% - 
    # which means rejecting the null and accepting the alternative 
    # hypothesis... as far as I can tell, unlike R, Python doesn't 
    # provide the % of the count

# %%
# Testing to see if you can do this w/o variables created
stat, pval = proportions_ztest(15, 43, 0.5)

print(stat, pval)

# %%
# Success! Same output as before.. seems a lot simpler...

# Testing to see if you can do this w/o print function
proportions_ztest(15, 43, 0.5)

# %%
# Success! Same output as before (in parenthesis now as only 
    # difference).. seems simpler...



# %%
# Page 5 - Two Proportion Testing in Python
stat, pval = proportions_ztest([7, 12], [15, 28])

print(stat, pval)

# %%
# 0.23974366706563624 0.810528980523634
    # Note: Because this p value is over 0.05, this determined that 
    # there is no significant different proportion between the two
    # categories - which means accepting the null and rejecting the 
    # alternative hypothesis... as far as I can tell, unlike R, Python 
    # doesn't provide the % of the counts for either category

# Testing to see if you can do this w/o print function
proportions_ztest([7, 12], [15, 28])

# %%
# Success! Same output as before (in parenthesis now as only 
    # difference).. seems simpler...



# %%
# Page 8 - Goodness of Fit Chi-Squares in Python

# Import packages
import scipy.stats
import numpy

# %%
# Import and preview data
swSurvey = pd.read_csv("/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 2. When Data Isn't Normal/SW_survey_renamed.csv")

swSurvey.head()

# %%
# Find observed values
swSurvey.FanYN.value_counts()

# %%
# Yes    552
# No     284
# Name: FanYN, dtype: int64


# %%
# Run analysis

    # Create new variables
observed = numpy.array([552, 284])

# %%
    # Math to calculate expected values (based on observed values
    # and expected percentage / proportion)
print((552 + 284) * 0.9)
print((552 + 284) * 0.1)

# %%
# 752.4 - rounded = 752
    # 83.60000000000001 - rounded = 84

expected = numpy.array([752, 84])

# %%
scipy.stats.chisquare(observed, f_exp = expected)

# %%
# Power_divergenceResult(statistic=529.3819655521784, 
    # pvalue=3.849512370977756e-117)

# Note: The p value is below 0.5, which means that observed and 
    # expected values are significantly different from each other (the 
    # sample varies from the population)



# %%
# Page 10 - McNemar Chi-Square Python

# Import packages
import statsmodels as sm
from statsmodels.stats.contingency_tables import mcnemar

# %%
# Import and preview data
bakery = pd.read_csv("/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 2. When Data Isn't Normal/bakery_sales.csv")

bakery.head()

# %%
# Goal: Do the sales of coffee change from the beginning of the month 
    # to the end of the month?

# Wrangling

    # Separate date column
bakery1 = bakery['Date'].str.split('/', expand = True).rename(columns = lambda x: 'Date' + str(x + 1))

bakery2 = pd.concat([bakery, bakery1], axis = 1)

bakery2.head()

# %%
    # Confirm variable data types
bakery2.info()

# %%
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 21293 entries, 0 to 21292
# Data columns (total 7 columns):
#  #   Column       Non-Null Count  Dtype 
# ---  ------       --------------  ----- 
#  0   Date         21293 non-null  object
#  1   Time         21293 non-null  object
#  2   Transaction  21293 non-null  int64 
#  3   Item         21293 non-null  object
#  4   Date1        21293 non-null  object
#  5   Date2        21293 non-null  object
#  6   Date3        21293 non-null  object
# dtypes: int64(1), object(6)
# memory usage: 1.1+ MB

# Note: Dates are all string - only concerned with day (Date2)

    # Change day to an integer
bakery2.Date2 = bakery2.Date2.astype(int)

bakery2.info()

# %%
# <class 'pandas.core.frame.DataFrame'>
# RangeIndex: 21293 entries, 0 to 21292
# Data columns (total 7 columns):
#  #   Column       Non-Null Count  Dtype 
# ---  ------       --------------  ----- 
#  0   Date         21293 non-null  object
#  1   Time         21293 non-null  object
#  2   Transaction  21293 non-null  int64 
#  3   Item         21293 non-null  object
#  4   Date1        21293 non-null  object
#  5   Date2        21293 non-null  int64 
#  6   Date3        21293 non-null  object
# dtypes: int64(2), object(5)
# memory usage: 1.1+ MB

# Note: Success!

    # Recode for beginning vs. end of month
def day (series):
    if series <= 15:
        return 0
    if series > 15:
        return 1

bakery2['DayR'] = bakery2['Date2'].apply(day)

bakery2.head()

# %%
# Looking good...

    # Recode for coffee vs. everything else
def item (series):
    if series == 'Coffee':
        return 1
    else:
        return 0

bakery2['coffee'] = bakery2['Item'].apply(item)

bakery2.head()

# %%
# Looks good

# Make crosstable
bakeryCrosstab = pd.crosstab(bakery2['DayR'], bakery2['coffee'])

bakeryCrosstab

# %%
# coffee	0	   1
#   DayR		
#      0 8238	2841
#      1 7584	2630

# Run anaylsis (and test assumptions)
result = sm.stats.contingency_tables.mcnemar(bakeryCrosstab, exact = False, correction = True)

print(result)

# %%
# pvalue      0.0
# statistic   2156.984556354916

# Note: The p value is below 0.05, so the results are likely 
    # significant (weird that it is exactly 0...)... doing this in R
    # ended up invalidating these results.. so it seems wiser to run
    # this kind of test in R!

# %%
# Test to see if it really needs to go into a new variable which is 
    # then printed
sm.stats.contingency_tables.mcnemar(bakeryCrosstab, exact = False, correction = True)

# %%
# It does ;)