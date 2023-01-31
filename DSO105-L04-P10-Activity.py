# %%
# DSO105 - Intermediate Statistics
    # Lesson 4 - Basic ANOVAs

# Page 10 - One Way ANOVAs in Python Activity

# Requirements: Using the YouTube Channels dataset edited for use 
    # in Python, determine if there is a difference in the number 
    # of views (Video views differs between all the different grade 
    # categories (Grade). To do this, you will need to:
        # Test for all assumptions and correct for them if possible
        # Run an ANOVA
        # If significant, run an ANOVA
        # Interpret your results
    # Then write an overall, one-sentence conclusion about this data analysis.


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
youtube = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/YouTubeChannels_Python.csv')

youtube

# %%
# 5000 rows × 6 columns
    # Note:
        # IV (x axis, categorical): Gr2de
        # DV (y axis, continuous): Video views
        # This also validates the sample size assumption (pre-
        # transformation, if needed)

# Exploration

    # Check for missing values
youtube.isna().sum()

# %%
# Rank             0
# Gr2de            0
# Channel name     0
# Video Uploads    0
# Subscribers      0
# Video views      0
# dtype: int64
    # Note: Phew, nothing to wrangle here


    # Confirm data types
youtube.info()

# %%
# Both the IV and DV are numeric (int64) - so no wrangling here, 
    # either


    # Confirm unique values / levels for IV
youtube.Gr2de.value_counts()

# %%
# 3    2956
# 2    1993
# 1      41
# 0      10
# Name: Gr2de, dtype: int64
    # Note: Only 4 - so it appears as though we don't need any
        # wrangling! (makes sense given that the requirements note
        # that the data was already "edited for use in Python")


# Test assumptions

    # Check for normal distribution
sns.distplot(youtube['Video views'])

# %%
# Very positively skewed


    # Transform
youtube['vidVwsSqrt'] = np.sqrt(youtube['Video views'])

youtube
# %%
# 5000 rows × 7 columns


    # Check distribution again
sns.distplot(youtube.vidVwsSqrt)

# %%
# Better but not great

    # Transform again
youtube['vidVwsLog'] = np.log(youtube['Video views'])

youtube

# %%
# 5000 rows × 8 columns

    # Check distribution again
sns.distplot(youtube.vidVwsLog)

# %%
# Now negatively skewed, though better - will use this


    # Check for homogeneity of variance
        # Note: B/c the transformed data can be considered to be
            # normally distributed, I will use Bartlett's test
scipy.stats.bartlett(youtube.vidVwsLog, youtube.Gr2de)

# %%
# BartlettResult(statistic=4642.606911455061, pvalue=0.0)
    # Note: This p value determined significance, which violates the
        # assumption - these data are heterogeneic
        # This also means the testing should stop here, or move to R, 
        # b/c Python has no option to correct for heterogeneic data
        # ... that said, I'll proceed, since that's the expectation 
        # (for practice)


# Confirm sample size
youtube.info()

# %%
# The transformed data still has 5,000 entries, so this assumption is
    # validated


# Run analysis

    # Find unique values / levels for IV
youtube.Gr2de.value_counts()

# %%
# 3    2956
# 2    1993
# 1      41
# 0      10
# Name: Gr2de, dtype: int64


    # Run analysis on each level, using transformed data, with 
        # normal distribution
stats.f_oneway(youtube.vidVwsLog[youtube.Gr2de == 3], 
    youtube.vidVwsLog[youtube.Gr2de == 2], 
    youtube.vidVwsLog[youtube.Gr2de == 1], 
    youtube.vidVwsLog[youtube.Gr2de == 0])

# %%
# F_onewayResult(statistic=283.85148674568444, pvalue=
        # 3.895240835935201e-170)
    # Note: This indicates significance (though not reliably, since
        # the data are heterogeneic), without indicating which pairs
        # are significant
        # Also noteworthy, I had to trial and error to confirm the 
        # values for Gr2de shouldn't be in quotes - which makes sense
        # given the fact that the data type is numeric


# Post hoc analysis on transformed data
youtubePostHoc = MultiComparison(youtube.vidVwsLog, youtube.Gr2de)
youtubePostHocResults = youtubePostHoc.tukeyhsd()

print(youtubePostHocResults)

# %%
# Multiple Comparison of Means - Tukey HSD, FWER=0.05 
# ====================================================
# group1 group2 meandiff p-adj   lower   upper  reject
# ----------------------------------------------------
#      0      1  -1.5233 0.0085   -2.76 -0.2865   True
#      0      2   -3.103    0.0 -4.2146 -1.9913   True
#      0      3  -4.1291    0.0 -5.2399 -3.0184   True
#      1      2  -1.5797    0.0  -2.133 -1.0264   True
#      1      3  -2.6059    0.0 -3.1573 -2.0544   True
#      2      3  -1.0262    0.0 -1.1278 -0.9245   True
# ----------------------------------------------------
    # Note: This indicates significance for all pairs(though not    
        # reliably, since the data are heterogeneic), without 
        # indicating high / low info


# Interpret results

    # Find means
youtube.groupby('Gr2de').mean()

# %%
#    Video views	   vidVwsSqrt	vidVwsLog
# Gr2de			
# 0	2.119909e+10	139631.341341	23.578544
# 1	6.053121e+09	 70951.341638	22.055279
# 2	1.676207e+09	 34678.089608	20.475580
# 3	5.265217e+08	 19943.101566	19.449400
    # Note: (If the data were homogeneic and these results could be
        # considered to be reliable) This determined that all grades 
        # significantly differ from all other grades in the number of 
        # views they receive
        # We do not have in this dataset a translation of the recoded
        # grade variable, but, as recoded, the lower the grade code, 
        # the higher the view count