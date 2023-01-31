# %%
# DSO105 - Intermediate Statistics
    # Lesson 1 - Basic Statistics in Python

# Page 3 - Single Sample t-Test Activity

# Requirements: Using the hybrid2013 dataset you worked with in the
    # lesson, determine whether a miles per gallon (mpg) rating of 40
    # is unusual for a hybrid car on the market in 2013. To do this,
    # you will need to test for the assumption of normality by
    # creating a histogram, and then run a single sample ttest

# %%
# Import packages
import pandas as pd
import numpy as np
from scipy.stats import norm
from scipy import stats

# %%
# Import and preview data
hybrid = pd.read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python Resume/hybrid2013.xlsx')

hybrid.head()

# %%
# Step 1 – test assumptions: normally distributed
hybrid['mpg'].hist()

# %%
# Note: the data is not normally distributed – as with the lesson
    # content, disproved assumptions can't stop me ;)


# %%
# Step 2 – Run the analysis
stats.ttest_1samp(hybrid['mpg'], 40)

# %%
# This confirms the t-statistic (4.427320491687408) and p value
    # (6.67005084670698e-05, which is less than 0.05), which confirm
    # that 40 mpg is significantly different from the average mpg, but
    # not whether it is higher or lower


# %%
# Step 3 - Find mean, to confirm if 40 mpg is higher or lower
hybrid.mpg.mean()

# %%
# 33.48837209302326
    # Note: This confirms that 40 mpg is significantly higher than
    # the median