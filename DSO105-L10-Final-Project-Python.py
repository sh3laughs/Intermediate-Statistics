# %%
# # DSO105 - Intermediate Statistics
    # Lesson 10 - Intermediate Statistics - Final Project
    # Page 1 - Data Science

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
# Fawn is a private investigator. She has taken a job for an 
    # insurance company. The insurance company has been paying out 
    # large amounts of money for workman’s comp claims, and they 
    # believe some of those claims are fraudulent. The insurance 
    # company wants Fawn and her associates to run surveillance to 
    # determine if the rate of fraud is higher than what the 
    # industry normally reports. Specifically, they want to know if 
    # the incidence of fraud among claimants is more than 16%.

# They provide Fawn with a random sample of 94 claimants who have 
    # been diagnosed as unable to perform any physical labor beyond 
    # light housekeeping activities. They have asked Fawn to observe 
    # the sample, and report back to them how many of the claimants 
    # are obviously doing things that are much more strenuous than 
    # light housekeeping, such as strenuous yard work, weightlifting 
    # at the gym or other strenuous sporting activities, etc.

# Fawn and her team spend about 8 weeks completing their 
    # observations, and report back to the insurance company that 28 
    # of the 94 claimants are not nearly as “disabled” as their 
    # diagnosis suggests. The insurance company wants to test the 
    # data.

# Complete a report for grading. The only data you need is to know 
    # that 28 of the 94 claimants are not nearly as “disabled” as 
    # their diagnosis suggests, and the hypothetical level of fraud 
    # is 16%.


# Because this is comparing one categorical component to an expected 
        # rate, I'll use a One Proportion z test
    # H0: The proportion of fraudulent cases in this sample is 
            # approx. equal to the expected proportion
        # H1: The proportion of fraudulent cases in this sample is 
            # different from the expected proportion

# %%

    # Create variables
count = 28
sample = 94
value = .16

# %%

    # Run the analysis
stat, pval = proportions_ztest(count, sample, value)

print(stat, pval)

# %%
# 2.9229268377264077 0.0034675798365736213
    # Note: This p value (0.003...) determined that there is a
        # significant difference between the proportion of fraudulent 
        # cases in this sample and the expected proportion of 
        # fraudulent cases; reject the null and accept the alternative 
        # hypothesis

    # Math to confirm if this sample proportion is higher or lower
28/94

# %%
# 0.2978723404255319
    # Higher!

# Scenario 1 Summary: 
    # The incidence of fraudulence in this sample is significantly 
    # higher than the expected rate; it's about to be an unhappy day
    # for some about-to-be-historic workers' comp recipients.

# %%

# Scenario 2: Independent Chi-Square test
# Medical researchers are trying to understand if four topical 
    # antiseptics are being used in the same ratio at three 
    # different clinics in town. They have access to medical records 
    # over the past 3 years, and have recorded each treatment where 
    # a topical antiseptic was used.

# Using a tally sheet, they have determined how many times each 
    # antiseptic was used in each of the three clinics, and they 
    # want to compare the antiseptic usage across the three clinics.

# Complete a report for grading. The data can be found in the 
    # following file: Antiseptic Data.


# Because this is determining influence of two different categorical
        # variables, I'll do an Independent Chi-Square test
    # IV (x axis, categorical): clinic
    # DV (y axis, categorical): antiseptic type
    # H0: The number of treatments is approx. equal regardless of
            # antiseptic type or clinic
        # H1: The number of treatments is different based on
            # antiseptic type and/ or clinic

# %%

    # Import and preview data
treatments = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 10. Intermediate Statistics - Final Project/antiseptics.csv')

treatments

# %%
# 12 rows, 3 columns (+ index)


    # Create and view pivot table
treatmentsPivot = pd.pivot_table(treatments, 
    index = 'Antiseptic Type', columns = 'Clinic', 
    values = 'Number of applications')

treatmentsPivot

# %%
# Repeatedly returning error: KeyError: 'Antiseptic Type'

        # See if renaming fixes
treatments.rename(columns = {'Antiseptic Type': 'AntisepticType'}, inplace = True)

treatments

# %%
# So odd.. it didn't update

        # Print values for that column
print(treatments['Antiseptic Type'])

# %%
# Doesn't work since it thinks the column name is wrong

        # Create new column with same data (manually.. since it's
            # possible w/ a tiny dataset like this)
treatments['Antiseptic Type'] = ['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B', 'C', 'D']

treatments

# %%
# Success!
    # NOTE: Only after resolving this way did I realize that the
        # starter code had addressed this issue - the column name 
        # had a space at the end of it; fortunately I got the same 
        # results - as well as practice troubleshooting on my own ;)


    # Create and view pivot table, take 2
treatmentsPivot = pd.pivot_table(treatments, 
    index = 'Antiseptic Type', columns = 'Clinic', 
    values = 'Number of applications')

treatmentsPivot

# %%

# Run analysis
stats.chi2_contingency(treatmentsPivot)

# %%
# (1.225920250023835,
#  0.9755850789571424,
#  6,
#  array([[ 21.95121951,  34.09756098,  87.95121951],
#         [ 73.32317073, 113.8953252 , 293.78150407],
#         [  8.99390244,  13.97052846,  36.03556911],
#         [ 45.73170732,  71.03658537, 183.23170732]]))
    # Note: p value (0.97...) determined there is no significant 
        # difference between the numbers of antiseptic treatments by
        # antiseptic type or by clinic; accept null and reject 
        # alternative hypothesis
        # Array shows 5 case/ cell assumption was validated


# Scenario 2 Summary: 
    # The number of antiseptic treatments is about the same,    
    # regardless of which type the treatment is, or where it is 
    # administered.

# %%

# Scenario 3: One-Way ANOVA test
# A financial institution is interested in the savings practices of 
    # different demographic groups. They have demographic data for 
    # all of their account holders, and have used those criteria to 
    # split their customers up into 4 groups.

# They are going to use the results to do some targeted marketing. 
    # In order to determine savings practices, they are going to use 
    # the average savings account balance over the past 3 months for 
    # their account holders. In other words, they will have one 
    # number (average account balance) for each account.

# Each demographic group has between 40 and 60 accounts they will 
    # look at.

# Complete a report for grading. The data can be found in this file.


# Because this is comparing a categorical variable with a continuous
        # variable, I'll use a One-Way ANOVA test
    # Goal: Confirm whether savings account balances differ by    
        # pre-grouped demographics
    # IV (x axis, categorical): demographic groups
    # DV (y axis, continuous): savings account balances
    # H0: Savings account balances are approx. equal for all    
            # demographic groups
        # H1: Savings account balances are different for different 
            # demographic groups

# Note: This time I did preview starter code *before* coding below,
    # though elected to use alternate names, as well as dropping 
    # missing values in its own line


# Import and preview data
savings = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 10. Intermediate Statistics - Final Project/savings.csv')

savings

# %%
# 58 rows x 4 columns
    # Note: For now this validates sample size assumption, but there
        # are some NA's to remove

# Wrangling

    # Drop NAs
savings.dropna(inplace=True)

savings.isna().sum()

# %%
# Success!

    # Convert data from wide to long
savings2 = pd.melt(savings, var_name = 'DemographicGroup', 
    value_name = 'Balance')

savings2

# %%
# 188 rows × 2 columns
    # Note: This is longer than I expected... but, in looking at it, it
        # makes sense because it has put all the values from 4 columns
        # into a single column, so that single columns has 4x as many
        # rows now


    # Recode categorical data to continuous
savings3 = savings2.replace(savings.columns, [0, 1, 2, 3])

savings3

# %%
# 188 rows × 2 columns
    # Note: Sample size validated!


# Test assumptions

    # Check for normal distribution
sns.displot(savings3.Balance)

# %%
# Pretty good! Will use this


    # Check for homogeneity of variance
scipy.stats.bartlett(savings3['Balance'], savings3['DemographicGroup'])

# %%
# BartlettResult(statistic=2938.783115266954, pvalue=0.0)
    # Note: Violated - which cannot be corrected for in Python


    # Confirm sample size
# This was validated above


# Run analysis (anyway)
stats.f_oneway(savings3['Balance'][savings3['DemographicGroup']==0],
               savings3['Balance'][savings3['DemographicGroup']==1],
               savings3['Balance'][savings3['DemographicGroup']==2],
               savings3['Balance'][savings3['DemographicGroup']==3])

# %%
# F_onewayResult(statistic=182.1594248901449, pvalue=7.
        # 677987753650121e-55)
    # Note: (If data had not violated the homogeneity of variance 
        # assumption) This Determined that there is a significant 
        # difference in savings account balances based on 
        # demographic groups – though we don't yet know high vs. 
        # low; reject the null and accept the alternative hypothesis


# Post hoc analysis
savingsPostHoc = MultiComparison(savings3.Balance, 
    savings3.DemographicGroup)
savingsPostHocResults = savingsPostHoc.tukeyhsd()

print(savingsPostHocResults)
# %%
#      Multiple Comparison of Means - Tukey HSD, FWER=0.05      
# ==============================================================
# group1 group2   meandiff  p-adj    lower       upper    reject
# --------------------------------------------------------------
#      0      1  -4669.8055   0.0  -6271.7836  -3067.8275   True
#      0      2 -14008.7953  -0.0 -15610.7734 -12406.8172   True
#      0      3  -8074.5721  -0.0  -9676.5502  -6472.5941   True
#      1      2  -9338.9898  -0.0 -10940.9679  -7737.0117   True
#      1      3  -3404.7666   0.0  -5006.7447  -1802.7885   True
#      2      3   5934.2232  -0.0   4332.2451   7536.2013   True
# --------------------------------------------------------------
    # Note: (If data had not violated the homogeneity of variance 
        # assumption) This determined that there is a significant 
        # difference in savings account balances between all 
        # demographic groups, though still not yet high vs. low


# Interpret results via means
savings3.groupby('DemographicGroup').mean()

# %%
# Note: Based on the means, the low to high demographic group order
    # is 2, 3, 1, 0


# Scenario 3 Summary: 
    # There is a significant difference in savings account balances
    # between all demographic groups and each other. The marketing 
    # targeting demographic group A should be geared towards more 
    # affluent clients, as that group has significantly higher
    # balances than all other demographic groups – and the marketing 
    # targeting demographic group C should be geared towards thrifty
    # spenders, as that group has significantly lower balances
    # than all other groups.

# %%
# Scenario 4: Two Proportion z test
# The local school board conducted a poll to gauge public sentiment 
    # about a school bond. They asked respondents if they favored or 
    # opposed a bond in the upcoming election. The respondents were 
    # asked some demographic questions, too.
# Complete a report for grading. The counts for the different groups 
    # are as follows:
        # With school age children and favorable - 374
        # With school age children and unfavorable - 129
        # Without school age children and favorable - 171
        # Without school age children and unfavorable - 74
        # Use these data to complete your analysis, and use alpha = 0.
            # 05.

# Because this is comparing the proportions (ratios) of two different 
        # categories to the whole
    # Variable 1: school-aged children
    # Variable 2: sentiment towards school bond
    # H0: The proportion of people with school-aged children who favor
        # a school bond is approx. equal to the proportion of people
        # without school-aged children who favor a school bond
    # H1: The proportion of people with school-aged children who favor
        # a school bond is different from the proportion of people
        # without school-aged children who favor a school bond

    # Math to confirm total # of parents with school-aged children
374 + 129

#  %%
# 503

    # Math to confirm total # of parents without school-aged children
171 + 74

#  %%
# 245

    # Create variables for the analysis
count = np.array([374, 171])
sample = np.array([503, 245])

#  %%

    # Run the analysis
stat, pval = proportions_ztest(count, sample)

print(stat, pval)

# %%
# 1.3156546893290748 0.18828996870412507
    # Note: This determined the proportions of parents with and without
        # school-aged children who are favorable towards a school bond
        # are not significantly different from each other; accept the 
        # null and reject the alternative hypothesis


# Scenario 4 Summary: 
    # About the same proportion of parents who have school-aged 
    # children as those who do not favor a school bond – and this 
    # proportion is higher for both groups than those who oppose a 
    # bond; the school board would be wise to move forward with a bond
    # while they have this favor on their side.