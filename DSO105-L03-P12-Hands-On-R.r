# DSO105 - Intermediate Statistics -----
  # Lesson 3 - Advanced Chi-Squares
  # Page 12 - Analyzing Data in R Hands-On

# Setup ------------------------------------------------------------
# Import packages
library(dplyr)
library(gmodels)
library(tidyr)

# Import and preview package
loans = read.csv("/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 2. When Data Isn't Normal/loans.csv")

View(loans)
# 21,957 rows, 5 columns

# Requirements ------------------------------------------------------------
# This hands on uses a dataset about bank loan data. It is located here. There 
    # is also a data dictionary to help you determine what variables to use.
  # For each part, check and correct for assumptions if possible, perform the 
    # appropriate categorical data analysis in R, and provide a one-sentence 
    # conclusion at the bottom of your program files about the analysis you 
    # performed.

# Part I ------------------------------------------------------------
# Please answer the following question.
  # Does the term of the loan influence loan status? If so, how?
    # H0: Loan term does not influence loan status
      # H1: Loan term influences loan status

  # Note: Because this is about influence, and the two variables are 
    # categorical, I'll use an Independent Chi-Square test

# Create crosstable
CrossTable(loans$term, loans$loan_status, expected = TRUE, sresid = TRUE, 
           format = 'SPSS')
# Part I Test Results ----------------------------------------------------------
# Cell Contents
#   |-------------------------|
#   |                   Count |
#   |         Expected Values |
#   | Chi-square contribution |
#   |             Row Percent |
#   |          Column Percent |
#   |           Total Percent |
#   |            Std Residual |
#   |-------------------------|
#   
#   Total Observations in Table:  21957 
# 
#                 | loans$loan_status 
#      loans$term | Charged Off |     Current |  Fully Paid |   Row Total | 
#    -------------|-------------|-------------|-------------|-------------|
#       36 months |       2029  |          0  |      14964  |      16993  | 
#                 |   2540.011  |    388.509  |  14064.480  |             | 
#                 |    102.808  |    388.509  |     57.530  |             | 
#                 |     11.940% |      0.000% |     88.060% |     77.392% | 
#                 |     61.822% |      0.000% |     82.342% |             | 
#                 |      9.241% |      0.000% |     68.151% |             | 
#                 |    -10.139  |    -19.711  |      7.585  |             | 
#    -------------|-------------|-------------|-------------|-------------|
#       60 months |       1253  |        502  |       3209  |       4964  | 
#                 |    741.989  |    113.491  |   4108.520  |             | 
#                 |    351.936  |   1329.961  |    196.941  |             | 
#                 |     25.242% |     10.113% |     64.645% |     22.608% | 
#                 |     38.178% |    100.000% |     17.658% |             | 
#                 |      5.707% |      2.286% |     14.615% |             | 
#                 |     18.760  |     36.469  |    -14.034  |             | 
#    -------------|-------------|-------------|-------------|-------------|
#    Column Total |       3282  |        502  |      18173  |      21957  | 
#                 |     14.947% |      2.286% |     82.766% |             | 
#    -------------|-------------|-------------|-------------|-------------|
#   
#   Statistics for All Table Factors
# 
# Pearson's Chi-squared test 
# 
# 
# Chi^2 =  2427.685     d.f. =  2     p =  0 
# 
#        Minimum expected frequency: 113.4913 

# Notes:
  # The expected values are all greater than 5, so the data meets the
    # normal distribution assumption
    # The p value is less than 0.05 (0 itself seems rare / suspicious), so the
      # test is significant; reject the null and accept the alternative 
      # hypothesis
    # For 36 month loans, significantly fewer than expected are charged off or 
      # current
    # For 36 month loans, significantly more than expected are fully paid
    # For 60 month loans, significantly more than expected are charged off or 
      # current
    # For 60 month loans, significantly fewer than expected are fully paid
  # After testing with lesson content, I excluded arguments that do not impact
    # results (per being default values, as included in lesson content)

# Part I Summary ------------------------------------------------------------
# This test proves significance for all intersections of the data - the 
  # expectation going into the test seemed to be that more loans with a 60 
  # month term, and less with a 36 month term, would be paid off... but the 
  # inverse ended up being true - 36 month loans are significantly more likely 
  # to be paid off, and 60 month loans significantly less.


# Part II ------------------------------------------------------------
# Please answer the following question.
  # How has the ability to own a home changed after 2009?
    # H0: The ability to own a home has not changed after 2009
      # H1: The ability to own a home has changed after 2009

  # Tip!
    # To reformat the Date column into a new column, use this code:
    # loans$DateR <- as.Date(paste(loans$Date), "%m/%d/%Y")

  # Note: Because this is looking at a change over time, and the two variables 
    # are categorical, I'll use an McNemar Chi-Square test

# Exploration

  # Confirm data types of variables
str(loans)
# 'data.frame':	21957 obs. of  5 variables:
# $ X: int  1 2 3 4 5 6 7 8 9 10 ...
# $ term: chr  " 36 months" " 60 months" " 36 months" " 36 months" ...
# $ loan_status: chr  "Fully Paid" "Charged Off" "Fully Paid" "Fully Paid" ...
# $ Date: chr  "12/1/2011" "12/1/2011" "12/1/2011" "12/1/2011" ...
# $ home_ownership: chr  "RENT" "RENT" "RENT" "RENT" ...
  # Note: Index (X) is numeric, other variables are string

  # Confirm unique values for home_ownership
unique(loans$home_ownership)
# [1] "RENT" "OWN"
  # Note: Perfect! Only 2 levels (a requirement for McNemar tests)


# Wrangling

  # Convert date column, using provided code ;)
loans$DateR = as.Date(paste(loans$Date), "%m/%d/%Y")

str(loans)
# 'data.frame':	21957 obs. of  6 variables:
# $ X: int  1 2 3 4 5 6 7 8 9 10 ...
# $ term: chr  " 36 months" " 60 months" " 36 months" " 36 months" ...
# $ loan_status: chr  "Fully Paid" "Charged Off" "Fully Paid" "Fully Paid" ...
# $ Date: chr  "12/1/2011" "12/1/2011" "12/1/2011" "12/1/2011" ...
# $ home_ownership: chr  "RENT" "RENT" "RENT" "RENT" ...
# $ DateR: Date, format: "2011-12-01" "2011-12-01" ...
  # Note: Success! DateR is date format

  # Recode DateR for 2009 before vs. after 2009

    # Separate DateR
loans1 = separate(loans, DateR, c('Year', 'Month', 'Day'),
                   sep = '-')

View(loans1)
# Success!

    # 2009 before vs. after 2009
loans1$YearR = NA
loans1$YearR[loans1$Year <= 2009] = 0
loans1$YearR[loans1$Year > 2009] = 1

View(loans1)
# Success!

# Run anaylsis (and test assumptions)
CrossTable(loans1$YearR, loans1$home_ownership, mcnemar = TRUE, expected = TRUE,
           sresid = TRUE, format = 'SPSS')
# Part II Test Results ---------------------------------------------------------
# Cell Contents
#   |-------------------------|
#   |                   Count |
#   |         Expected Values |
#   | Chi-square contribution |
#   |             Row Percent |
#   |          Column Percent |
#   |           Total Percent |
#   |            Std Residual |
#   |-------------------------|
#   
#   Total Observations in Table:  21957 
# 
#               | loans1$home_ownership 
#  loans1$YearR |      OWN  |     RENT  | Row Total | 
#  -------------|-----------|-----------|-----------|
#             0 |      550  |     3408  |     3958  | 
#               |  551.239  | 3406.761  |           | 
#               |    0.003  |    0.000  |           | 
#               |   13.896% |   86.104% |   18.026% | 
#               |   17.986% |   18.033% |           | 
#               |    2.505% |   15.521% |           | 
#               |   -0.053  |    0.021  |           | 
#  -------------|-----------|-----------|-----------|
#             1 |     2508  |    15491  |    17999  | 
#               | 2506.761  | 15492.239 |           | 
#               |    0.001  |    0.000  |           | 
#               |   13.934% |   86.066% |   81.974% | 
#               |   82.014% |   81.967% |           | 
#               |   11.422% |   70.552% |           | 
#               |    0.025  |   -0.010  |           | 
#  -------------|-----------|-----------|-----------|
#  Column Total |     3058  |    18899  |    21957  | 
#               |   13.927% |   86.073% |           | 
#  -------------|-----------|-----------|-----------|
#   
#   Statistics for All Table Factors
# ...Not including Pearson's Chi-squared test results here... 
#  
# McNemar's Chi-squared test 
# 
#   Chi^2 =  136.9168     d.f. =  1     p =  1.257426e-31 
# 
# 
# McNemar's Chi-squared test with continuity correction 
# 
# Chi^2 =  136.6127     d.f. =  1     p =  1.465517e-31 
#  
#        Minimum expected frequency: 551.2394

# Note: The expected values are greater than 5 for all cells, so it can be 
    # considered to be normally distributed (meets assumption)
  # The p value is well below 0.05, so the results are likely significant
  # No standard residuals are above 2 or below -2, so the results are not 
    # significant, after all; accept the null and reject the alternative 
    # hypothesis

# Part II Summary ------------------------------------------------------------
# Although the test assumption was met and the p value seemed to prove 
  # significance, the standard residuals disproved significance - determining
  # that there is no significant difference in the ability to own a home in the
  # time period within the data that follows 2009 from the data in 2009 and
  # before.


# Part III ------------------------------------------------------------
# Please answer the following question.
  # The news just ran a story that only 15% of homes are fully paid for in 
    # America, and that another 10% have given up on paying it back, so the 
    # bank has "charged off" the loan. Does it seem likely that the data for 
    # this hands on came from the larger population of America?
      # H0: The data is from the US
        # H1: The data is not from the US

# Note: Because this is looking at whether your sample data could feasibly come 
  # from the population as a whole and because the data are categorical, , I'll 
  # use a Goodness of Fit Chi-Square test

# Wrangling

  # Find observed values
loans %>% group_by(loan_status) %>% summarise(count = n())
# A tibble: 3 × 2
# loan_status count
#   <chr>       <int>
# 1 Charged Off  3282
# 2 Current       502
# 3 Fully Paid  18173

  # Calculate 'Current' percentage
100 - 15 - 10
# [1] 75


# Run analysis

  # Create variables
observed = c(3282, 502, 18173)
expected = c(0.15, 0.75, 0.1)

  # Run test
chisq.test(x = observed, p = expected)
# Chi-squared test for given probabilities
# 
# data:  observed
# X-squared = 131740, df = 2, p-value < 2.2e-16

# Note: The p value is well below 0.5, which means that observed and expected
  # values are significantly different from each other (the sample varies
  # significantly from the population); reject the null and accept the 
  # alternative hypothesis

  # Test to be sure results are the same when only 2 values included (as in
    # lesson content)
observed1 = c(3282, 18173)
expected1 = c(0.15, 0.1)

# Run test
chisq.test(x = observed1, p = expected1)
# Error in chisq.test(x = observed1, p = expected1) : 
#   probabilities must sum to 1.
  # Aaah, right, so what matters is having 100% total, not how many values it
    # takes to get there!

# Part III Summary ------------------------------------------------------------
# Because the test determined a significant difference between this sample and
  # the population (the USA), the sample either is from another country, 
  # another total time frame than the data the news article referenced, or 
  # there is another explanation to be determined... in other words, this 
  # sample did not come from the population the news article referenced.