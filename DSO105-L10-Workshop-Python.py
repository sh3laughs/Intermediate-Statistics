# %%
# DSO105 - Intermediate Statistics
    # Lesson 10 - Intermediate Statistics - Final Project
    # Page 1 - Data Science

    # From video workshop - https://vimeo.com/447710352

# Import packages
import numpy as np
import pandas as pd
import seaborn as sns
import scipy
from scipy import stats
from statsmodels.stats.multicomp import MultiComparison
from statsmodels.stats.multicomp import pairwise_tukeyhsd
from statsmodels.stats.proportion import proportions_chisquare
from statsmodels.stats.proportion import proportions_ztest

# %%

    # Scenario 1: One Proportion z test
        # Total sample of Texans: 195
        # Count of Texans (in sample) with cowboy boots: 135
        # % of all Texans with cowboy boots: 75%
        # H0: Data will have 75% with cowboy boots
            # H1: Data will not have 75% with cowboy boots

count = 135
sample = 195
value = .75

stat, pval = proportions_ztest(count, sample, value)

print(stat, pval)

# %%
# -1.7455300054711183 0.08089265412686554
    # Note: p value (0.08...) determines that there is no
        # significance - the number of people from sample with 
        # cowboy boots is approx. 75%; accept null and reject 
        # alternative hypothesis

# %%

    # Scenario 2: Independent Chi-Square test
        # Does # of therapy pets differs by pet type or location?
        # IV (x axis, categorical): location
        # DV (y axis, categorical): pet type
        # H0: The # of therapy pets does not differ by location or 
                # pet type
            # H1: The # of therapy pets does differ by location and/ 
                # or pet type


# Import and preview data
therapyPets = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 10. Intermediate Statistics - Final Project/PetTherapy.csv')

therapyPets

# %%
# 12 rows, 3 columns (+ index)


# Create and view pivot table
petPivot = pd.pivot_table(therapyPets, index='PetType', 
    columns='Location', values='NumberTherapyVisitRequests')

petPivot

# %%
# Success!

# Run analysis
stats.chi2_contingency(petPivot)

# %%
# (7.34139487302036,
#  0.29042548747936403,
#  6,
#  array([[  4.98155738,   8.08196721,  20.93647541],
#         [ 21.97745902,  35.6557377 ,  92.36680328],
#         [ 43.66188525,  70.83606557, 183.50204918],
#         [ 72.37909836, 117.42622951, 304.19467213]]))
    # Note: p value (0.29...) determined there is no significant 
        # difference between numbers of therapy pets by location or 
        # pet type
        # Array shows we just barely met 5 case/ cell assumption 
        # (irrelevant per no significance); accept null and reject 
        # alternative hypothesis

# %%

    # Scenario 3: One Way ANOVA test
        # Confirm whether # of citations differ by scientific
            # journal publisher
        # IV (x axis, categorical): publisher
        # DV (y axis, continuous): # of citations
        # H0: The number of citations is approx. equal for all 
                # publishers
            # H1: The number of citations is different for different
                # publishers

# Import and preview data
impact = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 10. Intermediate Statistics - Final Project/ImpactFactor.csv')

impact

# %%
# 310 rows x 4 columns

# Wrangling

    # Convert data from wide to long
impactExpand = pd.melt(impact, var_name='Group', 
    value_name='Citations')

impactExpand

# %%
# 1240 rows × 2 columns
    # Note: that is longer than expected...


    # Recode categorical data to continuous
impact2 = impactExpand.replace(impact.columns, [0, 1, 2, 3])

impact2

# %%
# 1240 rows × 2 columns

    # Drop NAs
impact2.dropna(inplace=True)

impact2.isna().sum()

# %%
# Success!


# Test assumptions

    # Check for normal distribution
sns.displot(impact2.Citations)

# %%
# Postively skewed

        # Transform
            # This was skipped in workshop..

    # Check for homogeneity of variance
scipy.stats.bartlett(impact2['Citations'], impact2['Group'])

# %%
# BartlettResult(statistic=11376.655202751012, pvalue=0.0)
    # Note: Violated - which cannot be corrected for in Python

# Run analysis
stats.f_oneway(impact2['Citations'][impact2['Group']==0],
    impact2['Citations'][impact2['Group']==1],
    impact2['Citations'][impact2['Group']==2],
    impact2['Citations'][impact2['Group']==3])

# %%
# F_onewayResult(statistic=1.6345321119995455, pvalue=0.
        # 18023390165215977)
    # Note: Determined no significance - there is no significant 
        # difference in the number of citations based on journal 
        # publisher; accept the null and reject the alternative 
        # hypothesis

# %%

    # Scenario 4: Two Proportion z test
        # Compare proportion of males and females who own or don't 
            # own cowboy boots
        # Variable 1: gender
        # Variable 2: cowboy boot ownership
        # H0: The proportion of men who own cowboy boots to men who 
                # don't is approx. equal to the same proportion for 
                # women
        # H1: The proportion of men who own cowboy boots to men who 
                # don't is different from the same proportion for 
                # women

count = np.array([58, 20])
sample = np.array([92, 77])

stat, pval = proportions_ztest(count, sample)

print(stat, pval)

# %%
# 4.814273957654004 1.4773602105768518e-06
    # Note: This deteremined the proportions for men and women are 
        # significantly different; reject the null and accept the 
        # alternative hypothesis
        # Need to do further investigation to confirm high vs. low