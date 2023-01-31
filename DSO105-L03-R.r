# DSO105 - Intermediate Statistics
  # Lesson 3 - Advanced Chi-Squares

# Page 2 - One Proportion Testing in R ----------------------------------------

# H0: There are approx. equal proportions of jelly beans and chocolate eggs
  # H1: There are very unequal proportions of jelly beans and chocolate eggs

prop.test(x = 15, n = 43, p = 0.5, alternative = 'two.sided', 
          correct = FALSE)
# 1-sample proportions test without continuity correction
  # 
  # data:  15 out of 43, null probability 0.5
  # X-squared = 3.9302, df = 1, p-value = 0.04743
  # alternative hypothesis: true p is not equal to 0.5
  # 95 percent confidence interval:
  #   0.2241859 0.4982822
  # sample estimates:
  #   p 
  # 0.3488372
# Our x was jelly beans in a sample of jelly beans and chocolate eggs in a
  # sample of candy from an Easter basket... these test statistics confirm 
  # that the p-value is less than 0.05, which mean that the proportion of 
  # jelly beans is significantly different than 50%;the sample estimate 
  # confirms that jelly beans represent 34.88% of the total candy in the 
  # sample - together telling us that jelly beans represent significantly
  # less than 50%, which means that we reject the null and accept the 
  # alternative hypothesis



# Page 4 - Two Proportion Testing in R ----------------------------------------

# H0: The proportion of pink vs. non-pink jelly beans is approx. equal to the
    # proportion of pink vs. non-pink chocolate eggs
  # H1: The proportion of pink vs. non-pink jelly beans is unequal to the
    # proportion of pink vs. non-pink chocolate eggs

prop.test(x = c(7, 12), n = c(15, 28), alternative = 'two.sided')
  # 2-sample test for equality of proportions with continuity correction
  # 
  # data:  c(7, 12) out of c(15, 28)
  # X-squared = 7.5808e-32, df = 1, p-value = 1
  # alternative hypothesis: two.sided
  # 95 percent confidence interval:
  #   -0.3119912  0.3881817
  # sample estimates:
  #   prop 1    prop 2 
  # 0.4666667 0.4285714 
# This p-value means there is not a significant proportional difference
  # between these categories (accept the null and reject the alternative
  # hypothesis) - in this case our c values were the number of pink jelly 
  # beans and chocolate eggs against the total (all colors) for each of 
  # those candy categories, so the results say that the proportion of pink 
  # jelly beans (46.67%) vs. all jelly beans is not significantly from the 
  # proportion of pink chocolate eggs (42.86%) vs. all chocolate eggs... 
  # so maybe the next question is whether the chocolate is pink (I love 
  # white chocolate, which it would then be! ;) or if it's the wrappers



# Page 6 - Independent Chi-Squares in R ---------------------------------------

# Install and import package
install.packages(gmodels)
library(gmodels)

# Import and preview data
swSurvey = read.csv("/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 2. When Data Isn't Normal/SW_survey_renamed.csv")

View(swSurvey)
# 1,186 rows, 38 columns


# Goal of test: Determine whether age category Age influences someone's ranking 
  # of Episode I: The Phantom Menace
    # H0: Age has no influence on someone's ranking
      # H1: Age influences someone's ranking

# Create crosstable
CrossTable(swSurvey$Age, swSurvey$RankI, fisher = TRUE, chisq = TRUE,
           expected = TRUE, sresid = TRUE, format = 'SPSS')
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
#   Total Observations in Table:  835 
# 
          #    | swSurvey$RankI 
# swSurvey$Age |        1  |        2  |        3  |        4  |        5  |        6  | Row Total | 
          #   -------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
          #    |        6  |        0  |        2  |        4  |        1  |        3  |       16  | 
          #    |    2.472  |    1.360  |    2.491  |    4.541  |    1.916  |    3.219  |           | 
          #    |    5.036  |    1.360  |    0.097  |    0.065  |    0.438  |    0.015  |           | 
          #    |   37.500% |    0.000% |   12.500% |   25.000% |    6.250% |   18.750% |    1.916% | 
          #    |    4.651% |    0.000% |    1.538% |    1.688% |    1.000% |    1.786% |           | 
          #    |    0.719% |    0.000% |    0.240% |    0.479% |    0.120% |    0.359% |           | 
          #    |    2.244  |   -1.166  |   -0.311  |   -0.254  |   -0.662  |   -0.122  |           | 
          #   -------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
#         > 60 |       53  |       22  |       36  |       50  |       13  |       18  |      192  | 
          #    |   29.662  |   16.326  |   29.892  |   54.496  |   22.994  |   38.630  |           | 
          #    |   18.362  |    1.972  |    1.248  |    0.371  |    4.344  |   11.017  |           | 
          #    |   27.604% |   11.458% |   18.750% |   26.042% |    6.771% |    9.375% |   22.994% | 
          #    |   41.085% |   30.986% |   27.692% |   21.097% |   13.000% |   10.714% |           | 
          #    |    6.347% |    2.635% |    4.311% |    5.988% |    1.557% |    2.156% |           | 
          #    |    4.285  |    1.404  |    1.117  |   -0.609  |   -2.084  |   -3.319  |           | 
          #   -------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
#        18-29 |       21  |       15  |       20  |       42  |       33  |       49  |      180  | 
          #    |   27.808  |   15.305  |   28.024  |   51.090  |   21.557  |   36.216  |           | 
          #    |    1.667  |    0.006  |    2.297  |    1.617  |    6.074  |    4.513  |           | 
          #    |   11.667% |    8.333% |   11.111% |   23.333% |   18.333% |   27.222% |   21.557% | 
          #    |   16.279% |   21.127% |   15.385% |   17.722% |   33.000% |   29.167% |           | 
          #    |    2.515% |    1.796% |    2.395% |    5.030% |    3.952% |    5.868% |           | 
          #    |   -1.291  |   -0.078  |   -1.516  |   -1.272  |    2.465  |    2.124  |           | 
          #   -------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
#        30-44 |       15  |       11  |       28  |       57  |       25  |       71  |      207  | 
          #    |   31.980  |   17.601  |   32.228  |   58.753  |   24.790  |   41.648  |           | 
          #    |    9.015  |    2.476  |    0.555  |    0.052  |    0.002  |   20.686  |           | 
          #    |    7.246% |    5.314% |   13.527% |   27.536% |   12.077% |   34.300% |   24.790% | 
          #    |   11.628% |   15.493% |   21.538% |   24.051% |   25.000% |   42.262% |           | 
          #    |    1.796% |    1.317% |    3.353% |    6.826% |    2.994% |    8.503% |           | 
          #    |   -3.003  |   -1.573  |   -0.745  |   -0.229  |    0.042  |    4.548  |           | 
          #   -------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
#        45-60 |       34  |       23  |       44  |       84  |       28  |       27  |      240  | 
          #    |   37.078  |   20.407  |   37.365  |   68.120  |   28.743  |   48.287  |           | 
          #    |    0.255  |    0.329  |    1.178  |    3.702  |    0.019  |    9.385  |           | 
          #    |   14.167% |    9.583% |   18.333% |   35.000% |   11.667% |   11.250% |   28.743% | 
          #    |   26.357% |   32.394% |   33.846% |   35.443% |   28.000% |   16.071% |           | 
          #    |    4.072% |    2.754% |    5.269% |   10.060% |    3.353% |    3.234% |           | 
          #    |   -0.505  |    0.574  |    1.085  |    1.924  |   -0.138  |   -3.063  |           | 
          #   -------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
          #   Column Total |      129  |       71  |      130  |      237  |      100  |      168  |      835  | 
          #    |   15.449% |    8.503% |   15.569% |   28.383% |   11.976% |   20.120% |           | 
          #   -------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
#   
#   Statistics for All Table Factors
# 
# Pearson's Chi-squared test 
# 
# Chi^2 =  108.1543     d.f. =  20     p =  4.257807e-14

# Note: The expected values are greater than 5 for 25/30 (83.33%) cells, so it 
    # can be considered to be normally distributed
  # The p value is well below 0.05, so the results are likely significant;
    # reject the null and accept the alternative hypothesis 
  # For unknown ages, significantly more than expected ranked Episode 1 first
  # For ages over 60, significantly more than expected ranked Episode 1 first
  # For ages over 60, significantly fewer than expected ranked Episode 1 fifth 
    # or sixth
  # For ages 18-29, significantly more than expected ranked Episode 1 fifth or 
    # sixth
  # For ages 30-44, significantly fewer than expected ranked Episode 1 first
  # For ages 30-44, significantly more than expected ranked Episode 1 sixth
  # For ages 45-60, significantly fewer than expected ranked Episode 1 sixth


# Testing to see which arguments actually need to be defined (by weeding
  # out those that are defaults and can be excluded)

  # Remove fisher
CrossTable(swSurvey$Age, swSurvey$RankI, chisq = TRUE, expected = TRUE, 
           sresid = TRUE, format = 'SPSS')
# Results appear to be identical!
  # fisher = TRUE is default, so fisher only needs to be included when
  # FALSE

  # Remove chisq
CrossTable(swSurvey$Age, swSurvey$RankI, expected = TRUE, sresid = TRUE, 
           format = 'SPSS')
# Results appear to be identical!
  # chisq = TRUE is default, so chisq only needs to be included when
  # FALSE

  # Remove expected
CrossTable(swSurvey$Age, swSurvey$RankI, sresid = TRUE, format = 'SPSS')
# Results are missing the Expected Values
  # expected = FALSE is default, so expected only needs to be included when
  # TRUE

  # Remove sresid
CrossTable(swSurvey$Age, swSurvey$RankI, expected = TRUE, format = 'SPSS')
# Results are missing Std Residual
  # sresid = FALSE is default, so sresid only needs to be included when
  # TRUE

  # Note: not testing format, b/c online I found default is 'SAS'


# Page 7 - Goodness of Fit Chi-Squares in R -----------------------------------

# Import package
library(dplyr)

# Goal of test: Determine whether 90% of survey respondents are SW fans
  # H0: Approx. 90% of survey respondents are SW fans
    # H1: More or less than 90% of survey respondents are SW fans

# Wrangling - find observed values
swSurvey %>% group_by(FanYN) %>% summarise(count = n())
# A tibble: 3 × 2
# FanYN count
# <chr> <int>
#   1 ""      350
# 2 "No"    284
# 3 "Yes"   552


# Run analysis
observed = c(552, 284)
expected = c(0.9, 0.1)

chisq.test(x = observed, p = expected)
# Chi-squared test for given probabilities
# 
# data:  observed
# X-squared = 533.76, df = 1, p-value < 2.2e-16

# Note: The p value is below 0.5, which means that observed and expected
  # values are significantly different from each other (the sample varies
  # from the population); reject the null and accept the alternative hypothesis


# Testing function w/o creating variables
### chisq.test(x = ([552, 284]), p = ([0.9, 0.1]))
# Doesn't work - with brackets, parenthesis, or both.. oh well ;)
  # Commented out line 216