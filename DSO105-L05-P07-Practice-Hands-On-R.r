# DSO105 - Intermediate Statistics
  # Lesson 5 - Repeated Measures ANOVAs
  # Page 7 - Honey Production Practice Hands-On

# Setup -----
# Import packages
library(car)
library(dplyr)
library(fastR2)
library(rcompanion)

# Import data
honey = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 5. Repeated Measures ANOVAs/honey.csv')

View(honey)
# 201 entries, 8 total columns
  # Note: This (pretransformed, if necessary) validates the sample size 
    # assumption


# Requirements: This hands on uses a dataset about honey production over the 
    # years. It is located here.
  # You will determine whether honey production totalprod has changed over 
    # the years (year) using a repeated measures ANOVA. Provide a one-sentence 
    # conclusion at the bottom of your program file about the analysis you 
    # performed.

# Note:
  # IV (x axis, categorical / time): year
  # DV (y axis, continuous): totalprod
  # H0: Honey production has not changed over time
    # H1: Honey production has changed over time


# Exploration -----

  # Find data types
str(honey)
# Note: totalprod and year are both numeric (num and int, respectively)...
  # no wrangling should be needed



# Test assumptions -----

  # Check for normal distribution
plotNormalHistogram(honey$totalprod)
# Positively skewed

    # Transform
honey$totalprodSqrt = sqrt(honey$totalprod)

View(honey)
# 201 entries, 9 total columns
  # Note: Still validates the sample size assumption

    # Check distribution again
plotNormalHistogram(honey$totalprodSqrt)
# Note: Better but not great

    # Transform again
honey$totalprodLog = log(honey$totalprod)

View(honey)
# 201 entries, 10 total columns
  # Note: Still validates the sample size assumption

    # Check distribution again
plotNormalHistogram(honey$totalprodLog)
# Note: Much better! Use this


  # Check for homogeneity of variance
bartlett.test(totalprodLog ~ year, data = honey)
# 	      Bartlett test of homogeneity of variances
# data:  totalprodLog by year
# Bartlett's K-squared = 0.098764, df = 4, p-value = 0.9988
  # Note: This p value above 0.05 validates the assumption - yay!


  # Confirm sample size
    # Note: This was repeatedly validated above

  # Should check for sphericity.. to be learned later ;)



# Run analysis -----
honeyRMAnova <- aov(totalprodLog ~ year + Error(state), 
                           honey)

summary(honeyRMAnova)
# Error: state
#           Df Sum Sq Mean Sq F value Pr(>F)
# year       1    2.6   2.571   0.272  0.605
# Residuals 39  368.6   9.452               
# 
# Error: Within
#            Df Sum Sq Mean Sq F value Pr(>F)  
# year        1  0.255 0.25543   5.798 0.0172 *
# Residuals 159  7.005 0.04406                 
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This p value under 0.05 determined that there is a significant
    # difference in total production of honey over time, though this doesn't 
    # indicate which years have higher/ lower production; reject the null and 
    # accept the alternative hypothesis


# Interpret results -----

  # Find means
honeyMeans = honey %>% group_by(year) %>% 
  summarise(totalprodMean = mean(totalprod))

View(honeyMeans)
# The total production fluctuated, but overall it went significantly down
  # over time