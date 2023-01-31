# %%
# DSO105 - Intermediate Statistics
    # Lesson 1 - Basic Statistics in Python

# Page 6 - Independent t-Test Activity

# Requirements: Using the hybrid2013 dataset you worked with in the
    # lesson, determine if the mean miles per gallon for a compact and
    # a large car differ from each other. To do this, you will need to
    # test for the assumption of normality for both groups by creating
    # a histogram, and then run an independent ttest.

# %%
# Import packages
import pandas as pd
import numpy as np
from scipy.stats import ttest_ind
from scipy import stats

# %%
# Import & preview data
hybrid = pd.read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/hybrid2013.xlsx')

hybrid.head()


# %%
# Step 1 - Test assumptions: normality
hybrid.mpg[hybrid.carclass == 'C'].hist()
# These data are roughly normally distributed

# %%
hybrid.mpg[hybrid.carclass == 'L'].hist()

# %%
# These data are even more roughly, or just not, normally distributed


# %%
# Step 2 - Run analysis
ttest_ind(hybrid.mpg[hybrid.carclass == 'C'], hybrid.mpg[hybrid.carclass == 'L'])

# %%
# Ttest_indResult(statistic=2.598820461640718,
        # pvalue=0.026545168887970098)
    # Note: This p value less than 0.05 validates that there is a
        # significant difference between the mpg of Compact and Large
        # hybrid cars – though not which is higher or lower


# %%
# Step 3 - Find avg. mpg per car class
hybrid.mpg[hybrid.carclass == 'C'].mean()

# %%
# 40.75

# %%
hybrid.mpg[hybrid.carclass == 'L'].mean()

# %%
# 28.5

# Note: The mean mpg of Compact hybrid cars (40.75) is significantly
    # higher than the mean mpg of Large hybrid cars (28.5)