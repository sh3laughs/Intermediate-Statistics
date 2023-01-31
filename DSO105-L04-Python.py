# %%
# DSO105 - Intermediate Statistics
    # Lesson 4 - Basic ANOVAs

# Page 8 - One Way ANOVAs in Python Setup

    # From video

# Goal: Determine whether staff member influences price


# Import packages
import pandas as pd
import numpy as np
import seaborn as sns
import scipy
from scipy import stats
from statsmodels.stats.multicomp import MultiComparison
from statsmodels.stats.multicomp import pairwise_tukeyhsd

# %%
# Import data
salonCxl = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/client_cancellations.csv')

salonCxl

# %%
# 243 rows × 11 columns
    # Note:
        # IV (x axis, categorical): staff
        # DV (y axis, continuous): avg price
        # This also validates the sample size assumption (pre-
        # transformation, if needed)


# Wrangling

    # Remove missing data
salonCxl.dropna(inplace=True)

salonCxl

# %%
# 241 rows × 11 columns

    # Confirm data types
salonCxl.info()

# %%
# Note: IV is string and DV is float64 (numeric, which is great)
    # Also noteworthy - this (pretransformed, if necessary) data has
    # 241 entries, which validates the sample size assumption


    # Recode IV to numeric
        # Confirm unique values / levels
salonCxl.staff.value_counts()

# %%
# JJ        68
# BECKY     61
# JOANNE    45
# KELLY     44
# SINEAD    19
# TANYA      4
# Name: staff, dtype: int64


    # Recode
def staffRecode(series):
    if series == 'JJ':
        return 0
    if series == 'BECKY':
        return 1
    if series == 'JOANNE':
        return 2
    if series == 'KELLY':
        return 3
    if series == 'SINEAD':
        return 4
    if series == 'TANYA':
        return 5

salonCxl['staffR'] = salonCxl.staff.apply(staffRecode)

salonCxl

# %%
# 241 rows × 12 columns


# Test assumptions

    # Check for normal distribution
sns.distplot(salonCxl['avg price'])

# %%
# Not too bad, but slightly positively skewed

    # Transform
salonCxl['avgPrcSqrt'] = np.sqrt(salonCxl['avg price'])

salonCxl

# %%
# 41 rows × 13 columns

    # Check distribution again
sns.distplot(salonCxl.avgPrcSqrt)

# %%
# Only a slight improvement, but video says to use it...

# Check for homogeneity of variance

    # Check transformed data (normal distribution)
scipy.stats.bartlett(salonCxl.avgPrcSqrt, salonCxl.staffR)

# %%
# BartlettResult(statistic=85.27913423862961, pvalue=2.59082839272849e-20)
    # Note: This p value determined significance, which violates the
        # assumption - these data are heterogeneic
        # This also means the testing should stop here, or move to R, 
        # b/c Python has no option to correct for heterogeneic data

    # Check original dataset (non-parametric)
scipy.stats.fligner(salonCxl.avgPrcSqrt, salonCxl.staffR)

# %%
# FlignerResult(statistic=14.041888591291224, pvalue=0.00017878330489283094)
    # Note: This p value also determined significance, which violates 
        # the assumption - these data are heterogeneic
        # This also means the testing should stop here, or move to R, 
        # b/c Python has no option to correct for heterogeneic data


# Confirm sample size
salonCxl.info()

# %%
# The transformed data still has 241 entries, so this assumption is
    # validated

# %%
    # From lesson

# Goal: Determine whether there a difference in the number of reviews 
    # among the three app categories of beauty, food and drink, and 
    # photography


# Import data
android = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/googleplaystore.csv')

android

# %%
# 10841 rows × 14 columns
    # Note:
        # IV (x axis, categorical): Category 
        # DV (y axis, continuous): Reviews
    # This also validates the sample size assumption (pre-
        # transformation, if needed)

# Wrangling

    # Find unique values for IV
android.Category.value_counts()

# %%
# Long list ;)

    # Filter to only include three levels for the IV
androidCategories = ['BEAUTY', 'FOOD_AND_DRINK', 'PHOTOGRAPHY']
android1 = android.Category.isin(androidCategories)
android2 = android[android1].copy()

android2

# %%
# 515 rows × 14 columns
    # Note: Far less data, but still validates sample size assumption

    # Confirm all three values were included in update
android2.Category.value_counts()

# %%
# PHOTOGRAPHY       335
# FOOD_AND_DRINK    127
# BEAUTY             53
# Name: Category, dtype: int64


    # Subset to only include IV and DV
android3 = android2[['Category', 'Reviews']]

android3

# %%
# 515 rows × 2 columns

    # Confirm data types
android3.info()

# %%
# Both variables are string

    # Update datatype for DV
android3.Reviews = android3.Reviews.astype(int)

android3.info()

# %%
# Success

    # Recode Category to numbers
def categoryRecode(series):
    if series == 'BEAUTY':
        return 0
    if series == 'FOOD_AND_DRINK':
        return 1
    if series == 'PHOTOGRAPHY':
        return 2

android3['catR'] = android3.Category.apply(categoryRecode)

android3

# %%
# 515 rows × 3 columns


    # Reconfirm values
android3.catR.value_counts()

# %%
# 2    335
# 1    127
# 0     53
# Name: catR, dtype: int64


    # Drop original Category column
android4 = android3[['catR', 'Reviews']]

android4

# %%
# 515 rows × 2 columns

    # Reconfirm values
android4.catR.value_counts()

# %%
# 2    335
# 1    127
# 0     53
# Name: catR, dtype: int64


# Test assumptions

    # Check for normal distribution
sns.distplot(android4.Reviews)

# %%
# Very positively skewed

    # Transform
android4['revSqrt'] = np.sqrt(android4.Reviews)

android4

# %%
# 515 rows × 3 columns

    # Check distribution again
sns.distplot(android4.revSqrt)

# %%
# Not great, but lesson says to run with it...


    # Check for homogeneity of variance

    # Check transformed data (supposedly - according to lesson normal 
        # distribution)
scipy.stats.bartlett(android4.revSqrt, android4.catR)

# %%
# BartlettResult(statistic=6187.981817647605, pvalue=0.0)
    # Note: This p value determined significance, which violates the
        # assumption - these data are heterogeneic
        # This also means the testing should stop here, or move to R, 
        # b/c Python has no option to correct for heterogeneic data


    # Check original dataset (non-parametric)
scipy.stats.fligner(android4.revSqrt, android4.catR)

# %%
# FlignerResult(statistic=642.0602581715318, pvalue=
        # 1.1908711834100128e-141)
    # Note: This p value also determined significance, which violates 
        # the assumption - these data are heterogeneic
        # This also means the testing should stop here, or move to R, 
        # b/c Python has no option to correct for heterogeneic data


    # Confirm sample size
android4.info()

# %%
# The transformed data still has 515 entries, so this assumption is
    # validated

# %%
# Page 9 - One Way ANOVAs in Python

    # From video

    # Note: We're going forward with tests, in spite of data being 
        # uncorrectably heterogeneic


# Run analysis

    # Find unique values / levels for IV
salonCxl.staff.value_counts()

# %%
# JJ        68
# BECKY     61
# JOANNE    45
# KELLY     44
# SINEAD    19
# TANYA      4
# Name: staff, dtype: int64

    # Run analysis on each level (transformed data, normal dist.)
stats.f_oneway(salonCxl.avgPrcSqrt[salonCxl.staff == 'JJ'],
    salonCxl.avgPrcSqrt[salonCxl.staff == 'BECKY'],
    salonCxl.avgPrcSqrt[salonCxl.staff == 'JOANNE'],
    salonCxl.avgPrcSqrt[salonCxl.staff == 'KELLY'],
    salonCxl.avgPrcSqrt[salonCxl.staff == 'SINEAD'],
    salonCxl.avgPrcSqrt[salonCxl.staff == 'TANYA'])

# %%
# F_onewayResult(statistic=8.109764971308326, pvalue=4.4521793522335193e-07)
    # Note: This finds significance, which means (if the data were
    # homogeneic) there is a significant difference in price by
    # staff member


# Post hoc analysis
salonCxlPostHoc = MultiComparison(salonCxl.avgPrcSqrt, salonCxl.staff)
salonCxlPostHocResults = salonCxlPostHoc.tukeyhsd()

print(salonCxlPostHocResults)

# %%
# Multiple Comparison of Means - Tukey HSD, FWER=0.05 
# ====================================================
# group1 group2 meandiff p-adj   lower   upper  reject
# ----------------------------------------------------
#  BECKY     JJ   1.0707 0.1053 -0.1199  2.2612  False
#  BECKY JOANNE   2.8075    0.0  1.4809  4.1342   True
#  BECKY  KELLY   0.9295 0.3453 -0.4058  2.2648  False
#  BECKY SINEAD   0.2797 0.9976  -1.494  2.0534  False
#  BECKY  TANYA  -0.1675    1.0 -3.6519  3.3169  False
#     JJ JOANNE   1.7369 0.0021  0.4395  3.0342   True
#     JJ  KELLY  -0.1412 0.9996 -1.4473   1.165  False
#     JJ SINEAD   -0.791 0.7863 -2.5428  0.9609  False
#     JJ  TANYA  -1.2382 0.9094 -4.7115  2.2352  False
# JOANNE  KELLY   -1.878 0.0028 -3.3094 -0.4467   True
# JOANNE SINEAD  -2.5278 0.0015 -4.3749 -0.6808   True
# JOANNE  TANYA   -2.975 0.1513 -6.4974  0.5473  False
#  KELLY SINEAD  -0.6498 0.9151  -2.503  1.2035  False
#  KELLY  TANYA   -1.097 0.9477 -4.6226  2.4286  False
# SINEAD  TANYA  -0.4472 0.9993 -4.1611  3.2667  False
# ----------------------------------------------------
    # Note: "reject" column indicates significance for these
            # pairs, though not high vs. low info:
        # BECKY JOANNE
        # JJ JOANNE
        # JOANNE  KELLY
        # JOANNE SINEAD


# Interpret results

    # Find means
salonCxl.groupby('staff').mean()

# %%
# 	        days in adv	avg price	staffR	avgPrcSqrt
# staff				
# BECKY	    7.295082	51.064590	1.0 	6.896776
# JJ	    5.029412	66.325588	0.0	    7.967442
# JOANNE	4.488889	108.042444	2.0 	9.704312
# KELLY	    3.863636	66.137727	3.0	    7.826262
# SINEAD	7.368421	52.733684	4.0 	7.176490
# TANYA	    2.000000	52.222500	5.0	    6.729286
    # Note: This indicates that prices are much higher Joanne than
    # any other staff member... so the pairs above all indicate that
    # other staff members' prices are significantly cheaper than 
    # Joanne's

# %%

    # From lesson

    # Note: We're going forward with tests, in spite of data being 
        # uncorrectably heterogeneic

# Run analysis

    # Find unique values / levels for IV
android4.catR.value_counts()

# %%
# 2    335
# 1    127
# 0     53
# Name: catR, dtype: int64


    # Run analysis on each level (transformed data, normal dist.)
stats.f_oneway(android.Reviews[android.Category == 'BEAUTY'], 
    android.Reviews[android.Category == 'FOOD_AND_DRINK'], 
    android.Reviews[android.Category == 'PHOTOGRAPHY'])

# %%
# F_onewayResult(statistic=11.467490725511773, pvalue=
    # 1.342932747373518e-05)
    # Note: The very low p value determines that the test is 
        # significant (or would be if it had validated the heterogeneity of variance assumption)

# Post hoc analysis

    # Transformed data
androidPostHoc = MultiComparison(android4.revSqrt, android4.catR)
androidPostHocResults = androidPostHoc.tukeyhsd()

print(androidPostHocResults)

# %%
#   Multiple Comparison of Means - Tukey HSD, FWER=0.05  
# ======================================================
# group1 group2 meandiff p-adj   lower    upper   reject
# ------------------------------------------------------
#      0      1   111.89 0.4062 -93.3095 317.0896  False
#      0      2  419.474    0.0 233.9776 604.9704   True
#      1      2  307.584    0.0 176.8235 438.3446   True
# ------------------------------------------------------
    # Note: These results indicate significance between beauty and 
        # photography apps and between food/drink and photography 
        # apps - though with no indication of high/ low.. given
        # that photography is in both significant pairs, (if this
        # data were reliable by being homogeneic) it must have 
        # significantly more or less reviews than the other 2 
        # categories


# Interpret results

    # Find means
android4.groupby('catR').mean()

# %%
# 	      Reviews	   revSqrt
# catR		
# 0	  7476.226415	 48.854024
# 1	 69947.480315	160.744038
# 2	637363.134328	468.328067
    # Note: This determines that photo apps have significantly more 
        # reviews than beauty or food/drink apps
# %%
