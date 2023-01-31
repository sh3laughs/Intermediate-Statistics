# %%
# DSO105 - Intermediate Statistics
    # Lesson 1 - Basic Statistics in Python

# Page 9 - Dependent t-Test Activity

# Requirements:Using the hybrid2012-13 dataset you worked with in the
    # lesson, determine if the mean miles per gallon changes from 2012
    # to 2013. To do this, you will need to test for the assumption of
    # normality for both groups by creating a histogram, and then run
    # a dependent ttest.

# Import packages
import pandas as pd
import numpy as np
from scipy import stats

# %%
# Import and preview data
hybrid = pd.read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/hybrid2012-13.xlsx')

hybrid.head()


# %%
# Step 1 - Test assumptions: normality
hybrid.mpg2012.hist()

# %%
# Note: These data are not normally distributed, but we're
    # proceeding anyway..

hybrid.mpg2013.hist()

# %%
# Note: These data are not normally distributed, but we're
    # proceeding anyway..


# %%
# Step 2 - Run anaylsis
stats.ttest_rel(hybrid.mpg2012, hybrid.mpg2013)

# %%
# Ttest_relResult(statistic=0.14466598084438315,
        # pvalue=0.8873759030512349)
    # Note: This p value is higher than 0.05, which means there is no
        # significant difference in mpg for hybrid cars from 2012 to
        # 2013