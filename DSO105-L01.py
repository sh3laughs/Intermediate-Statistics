# %%
# DSO105 - Intermediate Statistics – Python
    # Lesson 1 - Basic Statistics in Python

# Page 1 - Introduction

    # From workshop – https://vimeo.com/444962753


# Import packages
import pandas as pd
import numpy as np
from scipy.stats import norm
from scipy import stats
from scipy.stats import ttest_ind
import matplotlib.pyplot as plt
import seaborn as sns

# %%

# Import and preview data
olympicEvents = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/olympicEvents.csv')

olympicEvents

# %%
# 271116 rows × 15 columns

# Wrangling

    # Drop NA's
olympicEvents.dropna(inplace=True)

olympicEvents

# %%
# 30181 rows × 15 columns
    # Note: Dropped a LOT of data!

# %%
# Single Sample t-test

    # Goal: Determine whether the average age is different from 22

    # Step 1 – test assumptions: normally distributed
olympicEvents['Age'].hist()

# %%
# Note: this is close enough to a bell curve to be considered normally 
    # distributed


    # Step 2 – Run the analysis
stats.ttest_1samp(olympicEvents['Age'], 22)

# %%
# Ttest_1sampResult(statistic=117.96999514411488, 
        # pvalue=0.0)
    # Note: This confirms the t-statistic (117.96999514411488) and p 
        # value (0.0 – which is clearly rounded, and is also clearly 
        # less than 0.05), which confirm the average age IS 
        # significantly different from 22, but not whether it is 
        # higher or lower


    # Step 3 - Find mean, to confirm if average age is higher or lower 
        # than 22
olympicEvents.Age.mean()

# %%
# 25.42901162983334
    # Note: this is HIGHER than 22; also a bit odd since I think of 
        # olympians as being young...

# %%

# Independent t-test

    # Goal: Determine whether the average age differs between men and 
        # women

    # Step 1 – test assumptions: normally distributed
olympicEvents.Age[olympicEvents.Sex == 'M'].hist()

# %%
# Note: this is close enough to a bell curve to be considered normally 
    # distributed

olympicEvents.Age[olympicEvents.Sex == 'F'].hist()

# %%
# Note: this is close enough to a bell curve to be considered normally 
    # distributed


    # Step 2 – Run the analysis
ttest_ind(olympicEvents.Age[olympicEvents.Sex == 
    'M'], olympicEvents.Age[olympicEvents.Sex == 'F'])

# %%
# Ttest_indResult(statistic=20.811905071131516, 
        # pvalue=1.5853311644818236e-95)
    # Note: This confirms the t-statistic (20.811905071131516) and p 
        # value (1.5853311644818236e-95, which is less than 0.05), 
        # which confirm the average age IS different between genders


    # Step 3 - Group by gender to find mean age for each
olympicEvents.groupby('Sex')['Age'].mean()

# %%
# Sex
# F    24.597585
# M    25.862942
# Name: Age, dtype: float64
    # Note: This confirms there's a little over a year difference 
        # between average ages for men and women athletes – women 
        # being younger

# %%

# Independent Chi-Square

    # Goal: Determine whether season influences numbers of medals by 
        # type (bronze, silver, gold)

    # Step 1 - create crosstab to see data
olympicsCrosstab = pd.crosstab(olympicEvents['Season'], 
    olympicEvents['Medal'])

olympicsCrosstab

# %%

    # Step 2 - run Chi-Square test AND test assumption (at least 5 
        # cases per cell)
stats.chi2_contingency(olympicsCrosstab)

# %%
# (3.4745101681496746,
#  0.17600285120006448,
#  2,
#  array([[8520.60793214, 8536.56098207, 8283.83108578],
#         [1627.39206786, 1630.43901793, 1582.16891422]]))
    # Note: This confirms the Chi-Square statistic (
        # 3.4745101681496746), p value (0.17600285120006448, which is 
        # over 0.05), and the expected values for each cell in the 
        # crosstab (the array); this also validates that the 
        # assumption is safe there are WELL over 5 cases per cell 
        # (each # in the array being in the thousands) – because the p 
        # value is not significant, we can safely say that seasons do 
        # not impact the numbers of medal types

# %%

# Correlation

    # Goal: Find correlation between height and weight
olympicEvents['Height'].corr(olympicEvents['Weight'])

# %%
# 0.8018308248560182
    # Note: This confirms correlation value (0.8018308248560179) which 
        # shows that the variables are strongly (above 0.7) and 
        # positively correlated (they both go up or down together)


    # Create a heatmap
sns.heatmap(olympicEvents.corr(), annot = True)

# %%
# Note: This is useful other than the ID variable being included; the 
    # only actually interesting (aka: strong) correlation is Height + 
    # Weight – all others are too weak to consider as correlated

# %%
# Page 2 - Single Sample t-Test

    # From video

        # Goal: Determine whether a fairway percentage of 60% came 
            # from the PGA data we have

# Import & preview data
golf = pd.read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/pgaTourData.xlsx')

golf

# %%
# 2312 rows × 18 columns


    # Step 1 – test assumptions: normally distributed
golf['Fairway Percentage'].hist()

# %%
# Note: a beautiful bell curve


    # Step 2 – Run the analysis
stats.ttest_1samp(golf['Fairway Percentage'], 60)

# %%
# Ttest_1sampResult(statistic=nan, pvalue=nan)
    # Note: there was missing data so the statistical values are both represented by NA's


        # Drop N/A values
golf2 = golf.copy()

golf2.dropna(inplace = True)

golf2

# %%
# 283 rows × 18 columns
    # Note: A lot of data dropped!


    # Re-run the analysis
stats.ttest_1samp(golf2['Fairway Percentage'], 60)

# %%
# Ttest_1sampResult(statistic=3.7303160457242943, 
        # pvalue=0.0002311972962950221)
    # Note: This confirms the t-statistic (3.7303160457242943) and p 
        # value (0.0002311972962950221, which is less than 0.05), 
        # which confirm that a fairway % of 60 is significantly 
        # different than the population – though we don't know if it 
        # is high or low


    # Find mean, to confirm if 60 is higher or lower than average
golf2['Fairway Percentage'].mean()

# %%
# 61.06745583038865
    # Note: the average is 61.06745583038865, which means the test 
        # above proved that 60% is significantly LOWER than the average

# %%

    # From lesson

        # Goal: determine whether a cost of $25,000 for a hybrid 
            # vehicle in 2013 is different than the mean cost

# Import & preview data
hybrid = pd.read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/hybrid2013.xlsx')

hybrid

# %%
# 42 rows x 9 columns (+ index)

    # Step 1 – test assumptions: normally distributed
hybrid['msrp'].hist()

# %%
# Note: this is definitively not normally distributed.. but apparently 
    # "oh well" because the lesson says to charge on


    # Step 2 – Run the analysis
stats.ttest_1samp(hybrid['msrp'], 25000)

# %%
# Ttest_1sampResult(statistic=6.003733172775179, 
        # pvalue=3.9231807518835515e-07)
    # Note: This confirms the t-statistic (6.003733172775179) and p 
        # value (3.9231807518835515e-07, which is less than 0.05), 
        # which confirm that $25k is significantly different from the 
        # average cost, but not whether it is higher or lower


    # Step 3 - Find mean, to confirm if $25k is higher or lower
hybrid.msrp.mean()

# %%
# 42943.48837209302
    # Note: the average is 42943.48837209302, which means the test 
        # above proved that $25k is significantly LOWER than the 
        # average


# %%
# Page 5 - Independent t-Test

    # From video

        # Goal: Determine whether one golfer's (Aaron Baddeley) 
            # fairway percentage is significantly different from 
            # another's (Ben Crane)

    # Step 1 - Test assumptions: normality
golf['Fairway Percentage'][golf['Player Name'] == 
    'Aaron Baddeley'].hist()

# %%
# Note: these data are not normally distributed, but we're going 
    # forward anyways

golf['Fairway Percentage'][golf['Player Name'] == 'Ben Crane'].hist()

# %%
# Note: These data are closer to a bell curve / normal distribution, 
    # though not really.. but still we march on


    # Step 2 - Run analysis
ttest_ind(golf['Fairway Percentage'][golf[
    'Player Name'] == 'Aaron Baddeley'],golf['Fairway Percentage'][
        golf['Player Name'] == 'Ben Crane'])

# %%
# Ttest_indResult(statistic=-10.268833783913568, 
        # pvalue=1.8966579178846264e-08)
    # Note: This confirms the t-statistic (10.268833783913568) and p 
        # value (1.8966579178846264e-08, which is less than 0.05), 
        # which confirm the fairway percentages for these golfers are 
        # significantly different from each other – though we don't 
        # know which is higher than the other


    # Step 3 - Find mean fairway percentage for each golfer
golf['Fairway Percentage'][golf['Player Name'] == 
    'Aaron Baddeley'].mean

# %%
# <bound method NDFrame._add_numeric_operations.<locals>.mean of 185     53.27
# 373     52.25
# 537     55.42
# 751     50.29
# 926     52.29
# 1107    50.71
# 1283    54.30
# 1465    55.67
# 1655    56.65
# Name: Fairway Percentage, dtype: float64>


golf['Fairway Percentage'][golf['Player Name'] == 'Ben Crane'].mean

# %%
# <bound method NDFrame._add_numeric_operations.<locals>.mean of 18      67.52
# 208     67.97
# 436     63.18
# 598     67.49
# 780     66.40
# 1023    60.94
# 1158    64.36
# 1325    67.06
# 1494    71.13
# Name: Fairway Percentage, dtype: float64>

    # Note: Aaron Baddeley's average fairway percentage is 
        # significantly lower (about 14%) than Ben Crane's

# %%
    # From lesson

        # Goal: Determine whether compact and mid-size hybrid cars 
            # differ in their average miles per gallon

    # Step 1 - Test assumptions: normality
hybrid.mpg[hybrid.carclass == 'C'].hist()

# %%

hybrid.mpg[hybrid.carclass == 'M'].hist()

# %%
# Note: these data are roughly normally distributed


    # Step 2 – Run analysis
ttest_ind(hybrid['mpg'][hybrid.carclass == 'C'], hybrid['mpg'][
    hybrid.carclass == 'M'])

# %%
# Ttest_indResult(statistic=1.0751886097093057, 
        # pvalue=0.29216712457079796)
    # Note: This confirms the t-statistic (1.0751886097093057) and p 
        # value (0.29216712457079796, which is greater than than 
        # 0.05), which confirm the mpg's for these hybrid car classes 
        # are not significantly different from each other


# %%

# Page 8 - Dependent t-Test

# Import and preview data
hybrid2 = pd.read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/hybrid2012-13.xlsx')

hybrid2

# %%
# 12 rows x 13 rows (+ index)

    # Goal: Determine whether the price of hybrid cars changes from 
        # 2012 to 2013

    # Step 1 - Test assumptions: normality
hybrid2['msrp2012'].hist()

# %%
# Note: These data are not normally distributed, which is the theme 
    # for this lesson

hybrid2['msrp2012'].hist()

# %%
# Note: These data are also not normally distributed, but oh well


    # Step 2 - Run anaylsis
stats.ttest_rel(hybrid2.msrp2012, hybrid2.msrp2013)

# %%
# Ttest_relResult(statistic=0.2374965077759743, 
        # pvalue=0.8162780348473798)
    # Note: This shows that the p value (0.8162780348473798) is 
        # greater than 0.05, which means there is no significant 


# %%

# Page 11 - Independent Chi-Square

# Import & preview data
lipstick = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/lead_lipstick.csv')

lipstick

# %%
# 223 rows × 8 columns

    # Goal: Determine whether the price of the product depends on 
        # whether it is a lip stick or a lip gloss

    # Step 1 - Create and view crosstab
lipstickCrosstab = pd.crosstab(lipstick.prodType, lipstick.priceCatgry)

lipstickCrosstab

# %%

    # Step 2 - Run analysis
stats.chi2_contingency(lipstickCrosstab)

# %%
# (0.2969891724608704,
#  0.8620046738525345,
#  2,
#  array([[17.58744395, 44.79820628, 11.61434978],
#         [35.41255605, 90.20179372, 23.38565022]]))
    # Note: This tells us the test statistic (0.2969891724608704), p 
        # value (0.8620046738525345, which is higher than 0.05), and 
        # frequencies (array, all of which are higher than 5) – which 
        # tell us there is no signficant difference in cost between 
        # lipsticks and lip glosses


# %%
# Page 14 - Correlation

    # From video

        # Goal: Determine how variables relate to each other in the 
            # PGA dataset

    # Step 1 - Find correlation between two variables
golf['Fairway Percentage'].corr(golf['Avg Distance'])

# %%
# -0.5338318311148584
    # Note: The data are negatively (when one goes up, the other goes 
        # down - and vice versa) but only moderately correlated


    # Step 2 - Drop categorical data
golf3 = golf.drop(['Player Name'], axis = 1)

golf3

# %%
# 2312 rows × 17 columns


    # Step 3 - Create a correlation matrix for the above two 
        # variables, using Pearson's R, to see other variables' 
        # correlation
golf3.corr()

# %%

    # Step 4 - Add additional arguments to have a more visually clear 
        # matrix
golf3.corr().style.format('{:.2}').background_gradient(
    cmap = plt.get_cmap('coolwarm'), axis = 1)

# %%
# Note: The strongest correlation is between money and points, though 
    # these are also strongly correlated: top 10 and points, top 10 
    # and money, wins and points, average SG total and money


    # Step 5 - create a heatmap instead
sns.heatmap(golf3.corr(), annot = True)

# %%
# Note: This is not a good option for this data because there are so 
    # many variables the numbers on the cells are illegible*

# %%

    # From lesson

# Import and preview data
cruise = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/cruise_ship.csv')

cruise

# %%
# 158 rows × 10 columns

    # Goal: Determine whether the number of passengers and the number 
        # of cabins on a cruise ship are related to each other

    # Step 1 - run correlation between 2 variables
cruise.passngrs.corr(cruise.Cabins)

# %%
# 0.9763413679845939
    # Note: The numbers of passengers and cabins are (not 
        # surprisingly) very strongly and positively (when one goes up 
        # or down, the other does the same) correlated


    # Step 2 - drop categorical data
cruise1 = cruise.drop(['Ship', 'Line'], axis = 1)

cruise1

# %%
# 158 rows × 8 columns


    # Step 3 - create a correlation matrix
cruise1.corr()

# %%

    # Step 4 - make the matrix easier to read
cruise1.corr().style.format('{:.2}').background_gradient(
    cmap = plt.get_cmap('coolwarm'), axis = 1)

# %%
# Note: There are lots of strong, positive correlations, and the 
    # strongest is: passngers and cabins


    # Step 5 - create a heatmap
sns.heatmap(cruise1.corr(), annot = True)

# %%
# Note: This is not as pretty, but was a lot easier to code for nearly 
    # as clear of info