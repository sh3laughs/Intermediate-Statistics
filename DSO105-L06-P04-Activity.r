# DSO105 - Intermediate Statistics
  # Lesson 6 - Mixed Measures ANOVAs
  # Page 4 - Mixed Measures ANOVAs in R Activity

# Requirements: Using the breakfast data from last page, determine whether 
  # weight loss changes from baseline to follow up based upon whether or not 
  # a person eats breakfast in the morning. In order to do this, you will need 
  # to:
    # Wrangle the data
    # Test for assumptions
    # Run the analysis for mixed measures ANOVA
  # IV 1 (x axis, categorical): treatment group (fasting or breakfast)
  # IV 2 (x axis, categorical / time): baseline / follow-up
  # DV (y axis, continuous): weight
  # H0: Eating breakfast has no impact on weight over time
    # H1: Eating breakfast has an impact on weight over time


# Setup -----

# Import packages
library(car)
library(dplyr)
library(rcompanion)


# Import data
breakyWeight = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 5. Repeated Measures ANOVAs/breakfast.csv')

View(breakyWeight)
# 150 entries, 141 total columns
  # Note: Sample size (40, per 2 IV's) validated (for now...)


# Wrangling -----

  # Remove NA's via saving only rows with values
breakyWeight1 = breakyWeight[1:33,]

View(breakyWeight1)
# 33 entries, 141 total columns
  # Note: Big difference!
  # Also, this now violates the sample size assumption (40, per 2 IV's)


  # Reshape data to be long (instead of wide)

    # Subset to only include defined columns
breakyWeightKeep = c('Participant.Code', 'Treatment.Group', 'Age..y.', 'Sex',
               'Height..m.', 'Baseline.Body.Mass..kg.', 
               'Follow.Up.Body.Mass..kg.')
breakyWeight2 <- breakyWeight1[breakyWeightKeep]

View(breakyWeight2)
# 33 entries, 7 total columns


  # Baseline data - keep first 5 columns of subset data, with baseline
    # weight renamed as 'repdat' and all data assigned 'T1' (test 1) in a new 
    # 'contrasts' column (contrasts between baseline and follow-up data)
breakyWeight3 = breakyWeight2[, 1:5]
breakyWeight3$repdat = breakyWeight2$Baseline.Body.Mass..kg.
breakyWeight3$contrasts = 'T1'

View(breakyWeight3)
# 33 entries, 7 total columns


  # Follow-up data - keep first 5 columns of subset data, with follow-up
    # weight renamed as 'repdat' (data that was repeated) and all data 
    # assigned 'T2' (test 2) in a new 'contrasts' column (contrasts between 
    # baseline and follow-up data)
breakyWeight4 = breakyWeight2[, 1:5]
breakyWeight4$repdat = breakyWeight2$Follow.Up.Body.Mass..kg.
breakyWeight4$contrasts = 'T2'

View(breakyWeight4)
# 33 entries, 7 total columns


  # Re-merge baseline and follow-up data
breakyWeight5 = rbind(breakyWeight3, breakyWeight4)

View(breakyWeight5)
# 66 entries, 7 total columns
  # Success! Data is reshaped ;)
  # IV 1 (x axis, categorical): Treatment.Group
  # IV 2 (x axis, categorical / time): contrasts
  # DV (y axis, continuous): repdat


# Test assumptions -----

  # Check for normal distribution - on pre-reshaped data, to ensure
    # baseline and follow-up data are taken into account separately

    # Baseline
plotNormalHistogram(breakyWeight2$Baseline.Body.Mass..kg.)
# It's not perfect, but close enough! Woo hoo!

  # Follow-up
plotNormalHistogram(breakyWeight2$Follow.Up.Body.Mass..kg.)
# This is also close enough to skip transformation - yay!


  # Check for homogeneity of variance
leveneTest(repdat ~ Treatment.Group * contrasts, data = breakyWeight5)
# Levene's Test for Homogeneity of Variance (center = median)
#       Df F value Pr(>F)
# group  3  0.0623 0.9795
#       62
  # Note: This p value above 0.05 validates the assumption - yay!


  # Confirm sample size (40, per 2 IV's)
View(breakyWeight5)
# 66 entries, 7 total columns
  # Validated! At least, I think it is... lesson implied our value is really
    # 33 (sample size per test), which would violate this assumption... 
    # though, as with lesson practice work, I'll proceed



# Run analysis -----
breakyWeightMMAnova = aov(repdat ~ (Treatment.Group * contrasts) + 
                      Error(Participant.Code / contrasts), breakyWeight5)

summary(breakyWeightMMAnova)
# Error: Participant.Code
#                 Df Sum Sq Mean Sq
# Treatment.Group  1  105.3   105.3
# 
# Error: Participant.Code:contrasts
#           Df Sum Sq Mean Sq
# contrasts  1  1.368   1.368
# 
# Error: Within
#                           Df Sum Sq Mean Sq F value Pr(>F)
# Treatment.Group            1     11   11.23   0.175  0.677
# contrasts                  1      0    0.30   0.005  0.946
# Treatment.Group:contrasts  1      0    0.22   0.003  0.954
# Residuals                 60   3842   64.04 
  # Note: All 3 p values are above 0.05, which means we determined that there
    # is no significant impact on weight over time, whether or not you eat 
    # breakfast
      # Treatment.Group - p 0.677: impact on weight based on whether or not 
        # subjects ate breakfast
      # contrasts - p 0.946: impact on weight over time
      # Treatment - p 0.954: impact on weight over time, based on whether or 
        # not subjects ate breakfast



# Summary -----
# There is no significant impact on weight over time, whether or not you eat 
    # breakfast