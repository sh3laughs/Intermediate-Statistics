# DSO105 - Intermediate Statistics -----
  # Lesson 4 - Basic ANOVAs
  # Page 6 - One Way ANOVA in R Activity

# Requirements: Using the YouTube Channels dataset, determine if there is a 
  # difference in the number of views (Video.views differs between all the 
  # different grade categories (Grade). To do this, you will need to:
    # Test for all assumptions and correct for them if necessary
    # Run the appropriate ANOVA based on your assumptions
    # If significant, run the appropriate post hoc based on your assumptions
    # Interpret your results
  # Then write an overall, one-sentence conclusion about this data analysis. 
  # H0: The # of views is approx. the same between all grade categories
    # H1: The # of views is different for different grade categories


# Import packages
library(dplyr)
library(rcompanion)
library(car)
library(ggplot2)
library(IDPmisc)


# Exploration -----
# Import and preview data
youtube = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/YouTubeChannels.csv')

View(youtube)
# 5,000 entries, 6 total columns
  # IV (x axis, categorical): Grade
  # DV (y axis, continuous): Video.views

# Confirm data types of all variables
str(youtube)
# Grade is string and Video.views is numeric.. so no wrangling needed
  # on this front

# Confirm # of levels for Grade
unique(youtube$Grade)
# "A++ " "A+ "  "A "   "  "   "A- "  "B+ " 
  # Note: This has 5 levels (and course warns against ANOVAs on more than
    # 4 levels) and missing values... because requirements don't specify
    # a way to consolidate the levels, I'll keep all 5, but will drop 
    # missing values


# Wrangling -----
  # Drop missing values
youtube2 = NaRV.omit(youtube)

View(youtube2)
# 5,000 entries, 6 total columns
  # Note: Hmmm... nothing was removed...

  # Trying another function...
youtube2 = na.omit(youtube)

View(youtube2)
# 5,000 entries, 6 total columns
  # Note: Still the same... 

  # Trying recoding...
youtube$GradeR[youtube$Grade == "A++ "] = "A++ "
youtube$GradeR[youtube$Grade == "A+ "] = "A+ "
youtube$GradeR[youtube$Grade == "A "] = "A "
youtube$GradeR[youtube$Grade == "  "] = NA
youtube$GradeR[youtube$Grade == "A- "] = "A- "
youtube$GradeR[youtube$Grade == "B+ "] = "B+ "

unique(youtube$GradeR)
# We have NA's at least...

  # Try again to drop NA's
youtube2 = NaRV.omit(youtube)

View(youtube2)
# 4,994 entries, 7 total columns
  # Success! :D


# Test for all assumptions and correct for them if necessary -----

# Check distribution
plotNormalHistogram(youtube2$Video.views)
# Very positively skewed

  # Transform
youtube2$viewsSqrt = sqrt(youtube2$Video.views)

View(youtube2)
# 4,994 entries, 8 total columns

  # Check distribution again
plotNormalHistogram(youtube2$viewsSqrt)
# Better but not great

  # Transform again
youtube2$viewsLog = log(youtube2$Video.views)

View(youtube2)
# 4,994 entries, 9 total columns

  # Check distribution again
plotNormalHistogram(youtube2$viewsLog)
# Better - use this (though it is negatively skewed)


# Check for homogeneity of variance

  # Bartlett's test for tranformed data (normally distributed)
bartlett.test(viewsLog ~ Grade, data = youtube2)
# 	Bartlett test of homogeneity of variances
# data:  viewsLog by Grade
# Bartlett's K-squared = 30.477, df = 4, p-value = 3.914e-06
  # Note: This determined the test is significant - which means the data
    # are heterogeneic, and violated this assumption
  
  # Fligner's test for tranformed data (non-parametric)
fligner.test(Video.views ~ Grade, data = youtube2)
# 	Fligner-Killeen test of homogeneity of variances
# data:  Video.views by Grade
# Fligner-Killeen:med chi-squared = 1371.3, df = 4, p-value < 2.2e-16
  # Note: This also determined the test is significant - which means the 
    # data are heterogeneic, and violated this assumption


# Check for sample size ≥ 20
  # Note: As seen in all the View()'s above, we have 4,994 entries, so 
    # this assumption is validated
  

# Run the appropriate ANOVA based on your assumptions -----

# Because we violated the assumption of homogeneity of variance, I'll
  # run a Welch's One Way test

  # Running test on transformed data (normally distributed)
youtube2Anova = lm(viewsLog ~ Grade, data = youtube2)

Anova(youtube2Anova, Type = 'II', white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# Response: viewsLog
# Df      F    Pr(>F)    
# Grade        4 290.24 < 2.2e-16 ***
#   Residuals 4989                     
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This indicates high significance - to be validated in post hoc 
    # testing


  # Running test on original dataset (non-parametric)
youtubeAnova = lm(Video.views ~ Grade, data = youtube2)

Anova(youtubeAnova, Type = 'II', white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# Response: Video.views
# Df      F    Pr(>F)    
# Grade        4 155.36 < 2.2e-16 ***
#   Residuals 4989                     
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This also indicates high significance - to be validated in post 
    # hoc testing


# Run the appropriate post hoc based on your assumptions -----

# Because the assumption of homogeneity of variance was violated, I'll
  # include a 'pool.sd = FALSE' argument

# Running post hoc test on transformed data (normally distributed)
pairwise.t.test(youtube2$viewsLog, youtube2$Grade, p.adjust = 'bonferroni',
                pool.sd = FALSE)
# 	Pairwise comparisons using t tests with non-pooled SD 
# data:  youtube2$viewsLog and youtube2$Grade 
#        A       A-      A+      A++    
#   A-   < 2e-16 -       -       -      
#   A+   3.2e-06 3.2e-12 -       -      
#   A++  1.1e-05 1.1e-06 0.00073 -      
#   B+   < 2e-16 < 2e-16 4.6e-16 3.6e-07
# P value adjustment method: bonferroni
  # Note: This indicates high significance - though we don't yet know high 
    # vs. low - for all pairs; reject the null and accept the alternative 
    # hypothesis


# Running post hoc test on original dataset (non-parametric)
pairwise.t.test(youtube2$Video.views, youtube2$Grade, 
                p.adjust = 'bonferroni', pool.sd = FALSE)
# 	Pairwise comparisons using t tests with non-pooled SD 
# data:  youtube2$Video.views and youtube2$Grade 
#        A       A-      A+      A++   
#   A-   < 2e-16 -       -       -     
#   A+   9.1e-05 2.4e-07 -       -     
#   A++  0.0069  0.0043  0.0275  -     
#   B+   < 2e-16 < 2e-16 2.5e-08 0.0036
# P value adjustment method: bonferroni
  # Note: Though significance is less for some pairs, this does also 
    # indicate high significance - though we don't yet know high vs. low - 
    # for all pairs; reject the null and accept the alternative hypothesis


# Interpret your results -----

# Find means

  # Transformed data (normally distributed)
youtube2Means = youtube2 %>% group_by(Grade) %>% 
  summarise(viewsMean = mean(viewsLog)) %>% arrange(desc(viewsMean))

View(youtube2Means)
# Not surprisingly, the higher the Grade, the higher the view count


  # Original dataset (non-parametric)
youtubeMeans = youtube %>% group_by(Grade) %>% 
  summarise(viewsMean = mean(Video.views)) %>% arrange(desc(viewsMean))

View(youtubeMeans)
# As with transformed data, the higher the grade, the higher the views
  # Note: The mean values in the transformed data are easier to understand
    # at a glance, per being so much smaller than the original's mean 
    # values - though these values are easier to see the significant 
    # difference in (ie: 21,199,091,193 for A++ is clearly a significant
    # difference from 6,053,120,621 for A+, whereas ~24 for A++ in the 
    # transformed data is less clearly a significant difference from ~22 
    # for A+ in that data)


# Write an overall, one-sentence conclusion about this data analysis. -----

# This test validates that, while higher graded videos receive more views, 
  # there is a significant difference in the number of views between all 
  # Grade categories and each other.