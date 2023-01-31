# DSO105 - Intermediate Statistics
  # Lesson 5 - Repeated Measures ANOVAs
  # Page 4 - Repeated Measures ANOVAs in R Activity

# Requirements: Using the breakfast data from last page, determine whether 
  # weight changes from baseline to follow up. In order to do this, you will 
  # need to:
    # Wrangle the data
    # Test for assumptions
    # Run the analysis for repeated measures ANOVA
  # H0: Weight does not change from baseline test to follow up
    # H1: Weight changes from baseline test to follow up


# Setup -----
# Import packages
library(car)
library(dplyr)
library(fastR2)
library(rcompanion)

# Import data
weight = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 5. Repeated Measures ANOVAs/breakfast.csv')

View(weight)
# 150 entries, 141 total columns
  # Note: Rows 34 and below are NA's... also.. this is a LOT of columns!
    # Also noteworthy - this (pretransformed, if necessary) validates the 
    # sample size assumption (40, per 2 IV's)


# Exploration -----

  # Find column names (to find variables)
colnames(weight)
# It's a long list ;) but I'll be using these:
  # [1] "Participant.Code"                                                           
  # [2] "Treatment.Group"                                                            
  # [3] "Age..y."                                                                    
  # [4] "Sex"                                                                        
  # [5] "Height..m."                                                                 
  # [6] "Baseline.Body.Mass..kg."                                                    
  # [7] "Follow.Up.Body.Mass..kg."



# Wrangling -----

  # Remove NA's via saving only rows with values
weight1 = weight[1:33,]

View(weight1)
# 33 entries, 141 total columns
  # Note: Big difference!


  # Reshape data to be long (instead of wide)

    # Subset to only include required columns
weight2 = weight1[, 1:7]

View(weight2)
# 33 entries, 7 total columns


    # Baseline data - keep first 5 columns of subset data, with baseline
      # weight renamed as 'repdat' and all data assigned 'T1' (test 1) in a 
      # new 'contrasts' column (contrasts between baseline and follow-up data)
weight3 = weight2[, 1:5]
weight3$repdat = weight2$Baseline.Body.Mass..kg.
weight3$contrasts = 'T1'

View(weight3)
# 33 entries, 7 total columns


    # Follow-up data - keep first 5 columns of subset data, with follow-up
      # weight renamed as 'repdat' and all data assigned 'T2' (test 2) in a 
      # new 'contrasts' column (contrasts between baseline and follow-up data)
weight4 = weight2[, 1:5]
weight4$repdat = weight2$Follow.Up.Body.Mass..kg.
weight4$contrasts = 'T2'

View(weight4)
# 33 entries, 7 total columns


    # Re-merge baseline and follow-up data
weight5 = rbind(weight3, weight4)

View(weight5)
# 66 entries, 7 total columns
  # Success! Data is reshaped ;)
  # IV (x axis, categorical / time): contrasts
  # DV (y axis, continuous): repdat
  


# Test assumptions -----

  # Check for normal distribution - on pre-reshaped data, to ensure
    # baseline and follow-up data are taken into account separately

    # Baseline
plotNormalHistogram(weight2$Baseline.Body.Mass..kg.)
# It's not perfect, but close enough! Woo hoo!

    # Follow-up
plotNormalHistogram(weight2$Follow.Up.Body.Mass..kg.)
# This is also close enough to skip transformation - yay!


  # Check for homogeneity of variance
leveneTest(repdat ~ contrasts, data = weight5)
# Levene's Test for Homogeneity of Variance (center = median)
#       Df F value Pr(>F)
# group  1  0.0119 0.9133
#       64
  # Note: This p value above 0.05 validates the assumption - yay!


  # Confirm sample size (40, per 2 IV's)
View(weight5)
# 66 entries, 7 total columns
  # Validated!


  # Should check for sphericity.. to be learned later ;)



# Run analysis -----
weightRMAnova <- aov(repdat ~ contrasts + Error(Participant.Code), 
                           weight5)

summary(weightRMAnova)
# Error: Participant.Code
#           Df Sum Sq Mean Sq F value Pr(>F)
# Residuals  1  105.3   105.3               
# Error: Within
#           Df Sum Sq Mean Sq F value Pr(>F)
# contrasts  1      2    1.64   0.027  0.871
# Residuals 63   3854   61.17  
  # Note: This p value over 0.05 determined that there is no significant
    # difference in weight based on time; accept the null and reject the 
    # alternative hypothesis