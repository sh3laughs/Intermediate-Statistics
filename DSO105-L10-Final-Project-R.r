# DSO105 - Intermediate Statistics
  # Lesson 10 - Intermediate Statistics Final Project
  # Page 1 - Data Science

# Import packages
library(car)
library(dplyr)
library(ggplot2)
library(gmodels)
library(IDPmisc)
library(rcompanion)
library(tidyr)

# Scenario 1: Setup -----
# Fawn is a private investigator. She has taken a job for an insurance company. 
  # The insurance company has been paying out large amounts of money for 
  # workman’s comp claims, and they believe some of those claims are fraudulent. 
  # The insurance company wants Fawn and her associates to run surveillance to 
  # determine if the rate of fraud is higher than what the industry normally 
  # reports. Specifically, they want to know if the incidence of fraud among 
  # claimants is more than 16%.
# They provide Fawn with a random sample of 94 claimants who have been 
  # diagnosed as unable to perform any physical labor beyond light housekeeping 
  # activities. They have asked Fawn to observe the sample, and report back to 
  # them how many of the claimants are obviously doing things that are much 
  # more strenuous than light housekeeping, such as strenuous yard work, 
  # weightlifting at the gym or other strenuous sporting activities, etc.
# Fawn and her team spend about 8 weeks completing their observations, and 
  # report back to the insurance company that 28 of the 94 claimants are not 
  # nearly as “disabled” as their diagnosis suggests. The insurance company 
  # wants to test the data.
# Complete a report for grading. The only data you need is to know that 28 of 
  # the 94 claimants are not nearly as “disabled” as their diagnosis suggests, 
  # and the hypothetical level of fraud is 16%.


# Because this is comparing one categorical component to an expected rate, 
    # I'll use a One Proportion z test
  # H0: The proportion of fraudulent cases in this sample is approx. equal to 
      # the expected proportion
    # H1: The proportion of fraudulent cases in this sample is different from 
      # the expected proportion


# Scenario 1: One Proportion z test -----
prop.test(x = 28, n = 94, p = 0.16, alternative = 'two.sided', correct = FALSE)
# 	1-sample proportions test without continuity correction
# data:  28 out of 94, null probability 0.16
# X-squared = 13.295, df = 1, p-value = 0.0002661
# alternative hypothesis: true p is not equal to 0.16
# 95 percent confidence interval:
#  0.2148444 0.3967721
# sample estimates:
#         p 
# 0.2978723
  # Note: This p value (0.0002661) determined that there is a significant 
    # difference (though not yet high vs. low) between the proportion of 
    # fraudulent cases in this sample and the expected proportion of fraudulent 
    # cases; reject the null and accept the alternative hypothesis


  # Math to confirm if this sample proportion is higher or lower
28/94
# 0.2978723
  # Higher!


# Scenario 1: Summary -----
  # The incidence of fraudulence in this sample is significantly higher than 
  # the expected rate; it's about to be an unhappy day for some about-to-be-
  # historic workers' comp recipients.



# Scenario 2: Setup -----
# Medical researchers are trying to understand if four topical antiseptics are 
  # being used in the same ratio at three different clinics in town. They have 
  # access to medical records over the past 3 years, and have recorded each 
  # treatment where a topical antiseptic was used.
# Using a tally sheet, they have determined how many times each antiseptic was 
  # used in each of the three clinics, and they want to compare the antiseptic 
  # usage across the three clinics.
# Complete a report for grading. The data can be found in the following file: 
  # Antiseptic Data.


# Because this is determining influence of two different categorical variables, 
   # I'll do an Independent Chi-Square test
  # IV (x axis, categorical): clinic
  # DV (y axis, categorical): antiseptic type
  # H0: The number of treatments is approx. equal regardless of antiseptic type 
      # or clinic
    # H1: The number of treatments is different based on antiseptic type and/ 
      # or clinic


  # Import and preview data
treatments = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 10. Intermediate Statistics - Final Project/antiseptics.csv')

View(treatments)
# 12 entries, 3 total columns


# Scenario 2: Wrangling ------

  # Convert data to format that can be used in a cross table
treatments2 = treatments[rep(row.names(treatments), 
                                 treatments$Number.of.applications), 1:2]

View(treatments2)
# 984 entries, 2 total columns
  # Note: 984 rows!! Used provided starter code and was not expecting this 
    # output... digging into it, it looks like what happened is that this 
    # creates a new dataframe which is subsetting the existing one to include 
    # only the first and second columns, while using the 'Number of 
    # Applications' column to created repeated row numbers... so I'm assuming 
    # this replication happens in such a way as to account for the values prior
    # to this wrangling

    # Confirm whether the sum of values in the 'Number of Applications' column
      # is 984
sum(treatments$Number.of.applications)
# 984
  # Hypothesis validated!


# Scenario 2: Independent Chi-Square test ------
  # Create a crosstable
CrossTable(treatments2$Clinic, treatments2$Antiseptic.Type, fisher = TRUE, 
           chisq = TRUE, expected = TRUE, sresid = TRUE, format = 'SPSS')
#    Cell Contents
# |-------------------------|
# |                   Count |
# |         Expected Values |
# | Chi-square contribution |
# |             Row Percent |
# |          Column Percent |
# |           Total Percent |
# |            Std Residual |
# |-------------------------|
# Total Observations in Table:  984 
#                       | antiseptExpand$Antiseptic.Type 
# antiseptExpand$Clinic |        A  |        B  |        C  |        D  | Row Total | 
# ----------------------|-----------|-----------|-----------|-----------|-----------|
#                     1 |       22  |       71  |        8  |       49  |      150  | 
#                       |   21.951  |   73.323  |    8.994  |   45.732  |           | 
#                       |    0.000  |    0.074  |    0.110  |    0.234  |           | 
#                       |   14.667% |   47.333% |    5.333% |   32.667% |   15.244% | 
#                       |   15.278% |   14.761% |   13.559% |   16.333% |           | 
#                       |    2.236% |    7.215% |    0.813% |    4.980% |           | 
#                       |    0.010  |   -0.271  |   -0.331  |    0.483  |           | 
# ----------------------|-----------|-----------|-----------|-----------|-----------|
#                     2 |       38  |      112  |       14  |       69  |      233  | 
#                       |   34.098  |  113.895  |   13.971  |   71.037  |           | 
#                       |    0.447  |    0.032  |    0.000  |    0.058  |           | 
#                       |   16.309% |   48.069% |    6.009% |   29.614% |   23.679% | 
#                       |   26.389% |   23.285% |   23.729% |   23.000% |           | 
#                       |    3.862% |   11.382% |    1.423% |    7.012% |           | 
#                       |    0.668  |   -0.178  |    0.008  |   -0.242  |           | 
# ----------------------|-----------|-----------|-----------|-----------|-----------|
#                     3 |       84  |      298  |       37  |      182  |      601  | 
#                       |   87.951  |  293.782  |   36.036  |  183.232  |           | 
#                       |    0.178  |    0.061  |    0.026  |    0.008  |           | 
#                       |   13.977% |   49.584% |    6.156% |   30.283% |   61.077% | 
#                       |   58.333% |   61.954% |   62.712% |   60.667% |           | 
#                       |    8.537% |   30.285% |    3.760% |   18.496% |           | 
#                       |   -0.421  |    0.246  |    0.161  |   -0.091  |           | 
# ----------------------|-----------|-----------|-----------|-----------|-----------|
#          Column Total |      144  |      481  |       59  |      300  |      984  | 
#                       |   14.634% |   48.882% |    5.996% |   30.488% |           | 
# ----------------------|-----------|-----------|-----------|-----------|-----------|
# Statistics for All Table Factors
# Pearson's Chi-squared test 
# ---
# Chi^2 =  1.22592     d.f. =  6     p =  0.9755851
  # Note: p value (0.9755851) determined there is no significant difference 
    # between the numbers of antiseptic treatments by antiseptic type or by 
    # clinic; accept null and reject alternative hypothesis
    # Expected results show 5 case/ cell assumption was validated


# Scenario 2: Summary -----
  # The number of antiseptic treatments is about the same, regardless of which 
  # type the treatment is, or where it is administered.



# Scenario 3: Setup -----
# A financial institution is interested in the savings practices of different 
  # demographic groups. They have demographic data for all of their account 
  # holders, and have used those criteria to split their customers up into 4 
  # groups.
# They are going to use the results to do some targeted marketing. In order to 
  # determine savings practices, they are going to use the average savings 
  # account balance over the past 3 months for their account holders. In other 
  # words, they will have one number (average account balance) for each account.
# Each demographic group has between 40 and 60 accounts they will look at.
# Complete a report for grading. The data can be found in this file.


# Because this is comparing a categorical variable with a continuous variable, 
    # I'll use a One-Way ANOVA test
  # Goal: Confirm whether savings account balances differ by pre-grouped 
    # demographics
  # IV (x axis, categorical): demographic groups
  # DV (y axis, continuous): savings account balances
  # H0: Savings account balances are approx. equal for all demographic groups
      # H1: Savings account balances are different for different demographic 
        # groups


# Import and preview data
savings = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 10. Intermediate Statistics - Final Project/savings.csv')

View(savings)
# 58 entries, 4 total columns
  # Note: For now this validates sample size assumption, but there are some 
    # NA's to remove


# Scenario 3: Wrangling -----

  # Remove missing values
savings2 = NaRV.omit(savings)

sum(is.na(savings2))
# Success!


  # Convert data from wide to long
savings3 = gather(savings2, key = 'DemographicGroup', value = 'Balance')

View(savings3)
# 188 entries, 2 total columns
  # Note: This validates sample size assumption


# Scenario 3: Test Assumptions -----

  # Check for normal distribution
plotNormalHistogram(savings3$Balance)
# Looks great! Will keep this


  # Check for homogeneity of variance
bartlett.test(savings3$Balance ~ savings3$DemographicGroup, data = savings3)
# 	Bartlett test of homogeneity of variances
# data:  savings3$Balance by savings3$DemographicGroup
# Bartlett's K-squared = 7.0935, df = 3, p-value = 0.06898
  # Note: This p-value violates this assumption


  # Check sample size
# Note: This assumption was validated above


# Scenario 3: One-Way ANOVA test -----
savingsAnova = lm(savings3$Balance ~ savings3$DemographicGroup, data = savings3)
	
Anova(savingsAnova, Type = 'II', white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# Response: savings3$Balance
#                            Df      F    Pr(>F)    
# savings3$DemographicGroup   3 152.05 < 2.2e-16 ***
# Residuals                 184                     
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This Determined that there is a significant difference in savings 
    # account balances based on demographic groups – though we don't yet know 
    # high vs. low; reject the null and accept the alternative hypothesis


# Scenario 3: Post Hoc Analysis -----
pairwise.t.test(savings3$Balance, savings3$DemographicGroup, 
                p.adjust = 'bonferroni')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  savings3$Balance and savings3$DemographicGroup 
#         Group.A Group.B Group.C
# Group.B 1.1e-11 -       -      
# Group.C < 2e-16 < 2e-16 -      
# Group.D < 2e-16 7.2e-07 < 2e-16
# P value adjustment method: bonferroni
  # Note: This determined that there is a significant difference in savings 
    # account balances between all demographic groups, though still not yet 
    # high vs. low


# Scenario 3: Interpret Results via Means -----
savingsMeans = savings3 %>% group_by(DemographicGroup) %>% 
  summarise(balanceMean = mean(Balance)) %>% arrange(desc(balanceMean))

View(savingsMeans)
# Note: Based on the means, the low to high demographic group order
    # is C, D, B, A


# Scenario 3: Summary
  # There is a significant difference in savings account balances between all 
  # demographic groups and each other. The marketing targeting demographic 
  # group A should be geared towards more affluent clients, as that group has 
  # significantly higher balances than all other demographic groups – and the 
  # marketing targeting demographic group C should be geared towards thrifty
  # spenders, as that group has significantly lower balances than all other 
  # groups.



# Scenario 4: Setup -----
# The local school board conducted a poll to gauge public sentiment about a 
  # school bond. They asked respondents if they favored or opposed a bond in 
  # the upcoming election. The respondents were asked some demographic 
  # questions, too.
# Complete a report for grading. The counts for the different groups are as 
    # follows:
  # With school age children and favorable - 374
  # With school age children and unfavorable - 129
  # Without school age children and favorable - 171
  # Without school age children and unfavorable - 74
  # Use these data to complete your analysis, and use alpha = 0.05.


# Because this is comparing the proportions (ratios) of two different 
      # categories to the whole
  # Variable 1: school-aged children
  # Variable 2: sentiment towards school bond
  # H0: The proportion of people with school-aged children who favor a school 
    # bond is approx. equal to the proportion of people without school-aged 
    # children who favor a school bond
  # H1: The proportion of people with school-aged children who favor a school 
    # bond is different from the proportion of people without school-aged 
    # children who favor a school bond


  # Math to confirm total # of parents with school-aged children
374 + 129
# 503

  # Math to confirm total # of parents without school-aged children
171 + 74
# 245


# Scenario 4: Two Proportion z test -----
prop.test(x = c(374, 171), n = c(503, 245), alternative = 'two.sided')
# 	2-sample test for equality of proportions with continuity correction
# data:  c(374, 171) out of c(503, 245)
# X-squared = 1.5081, df = 1, p-value = 0.2194
# alternative hypothesis: two.sided
# 95 percent confidence interval:
#  -0.0264605  0.1176197
# sample estimates:
#    prop 1    prop 2 
# 0.7435388 0.6979592 
  # Note: This determined the proportions of parents with and without school-
    # aged children who are favorable towards a school bond are not 
    # significantly different from each other; accept the null and reject the 
    # alternative hypothesis


# Scenario 4: Summary -----
  # About the same proportion of parents who have school-aged children as those 
  # who do not favor a school bond – and this proportion is higher for both 
  # groups than those who oppose a bond; the school board would be wise to move 
  # forward with a bond while they have this favor on their side.