# DSO105 - Intermediate Statistics
  # Lesson 6 - Mixed Measures ANOVAs

# Page 2 - Mixed Measures ANOVAs in R Setup -----

  # From video -----
    # Note: We are starting with data as it was left off with the same data
      # in lesson 5 (page 3) video

# Goal: Determine whether coup risk changes over time and whether military
  # career has any influence on the coup
    # Btw. subjects IV: year
    # W/in subjects IV: military career
  # H0: Coup risk is consistent over time and military career has no influence
    # H1: Coup risk changes over time and/or military career has an influence

# Import packages
library(car)
library(dplyr)
library(rcompanion)

# Import data
coupRisk = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 6. Mixed Measures ANOVAs/coup_risk.csv')

View(coupRisk)
# 13,048 entries, 48 total columns
  # Note: Sample size assumption (40, per 2 IV's) validated

# Test assumptions

  # Normal distribution was validated via transformation in prior work - 
    # use coupriskLog variable

  # Homogeneity of variance was violated

  # Sample size validated above (line 25)



  # From lesson -----
  
# Goal: Determine whether those who ate breakfast in the morning improve 
  # their resting metabolic rate from baseline to follow up compared to those 
  # who skipped breakfast?  
    # IV 1 (x axis, categorical): treatment group (fasting or breakfast)
    # IV 2 (x axis, categorical / time): baseline / follow-up
    # DV (y axis, continuous): resting metabolic rate
    # H0: Eating breakfast has no impact on resting metabolic rate
      # H1: Eating breakfast has an impact on resting metabolic rate


# Import data
breaky = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 5. Repeated Measures ANOVAs/breakfast.csv')

View(breaky)
# 150 entries, 141 total columns
  # Note: Sample size (40, per 2 IV's) validated (for now...)


# Wrangling
  # Note: This is copied from lesson 5 practice work, with updates - based on 
    # new test - to dataframe name, sample size, and IV / DV info

  # Remove NA's via saving only rows with values
breaky1 = breaky[1:33,]

View(breaky1)
# 33 entries, 141 total columns
  # Note: Big difference!
  # Also, this now violates the sample size assumption (40, per 2 IV's)


  # Reshape data to be long (instead of wide)

    # Subset to only include defined columns
breakyKeep = c('Participant.Code', 'Treatment.Group', 'Age..y.', 'Sex',
               'Height..m.', 'Baseline.Resting.Metabolic.Rate..kcal.d.', 
               'Follow.Up.Resting.Metabolic.Rate..kcal.d.')
breaky2 <- breaky1[breakyKeep]

View(breaky2)
# 33 entries, 7 total columns


  # Baseline data - keep first 5 columns of subset data, with baseline
    # resting metabolic rate renamed as 'repdat' and all data assigned
    # 'T1' (test 1) in a new 'contrasts' column (contrasts between baseline 
    # and follow-up data)
breaky3 = breaky2[, 1:5]
breaky3$repdat = breaky2$Baseline.Resting.Metabolic.Rate..kcal.d.
breaky3$contrasts = 'T1'

View(breaky3)
# 33 entries, 7 total columns


  # Follow-up data - keep first 5 columns of subset data, with follow-up
    # resting metabolic rate renamed as 'repdat' (data that was repeated) 
    # and all data assigned 'T2' (test 2) in a new 'contrasts' column 
    # (contrasts between baseline and follow-up data)
breaky4 = breaky2[, 1:5]
breaky4$repdat = breaky2$Follow.Up.Resting.Metabolic.Rate..kcal.d.
breaky4$contrasts = 'T2'

View(breaky4)
# 33 entries, 7 total columns


  # Re-merge baseline and follow-up data
breaky5 = rbind(breaky3, breaky4)

View(breaky5)
# 66 entries, 7 total columns
  # Success! Data is reshaped ;)
  # IV 1 (x axis, categorical): Treatment.Group
  # IV 2 (x axis, categorical / time): contrasts
  # DV (y axis, continuous): repdat


# Test assumptions
  # Note: Distribution code is copied from lesson 5, with dataframe name
    # updated for this test

  # Check for normal distribution - on pre-reshaped data, to ensure
    # baseline and follow-up data are taken into account separately

    # Baseline
plotNormalHistogram(breaky2$Baseline.Resting.Metabolic.Rate..kcal.d.)
# It's not perfect, but close enough! Woo hoo!

  # Follow-up
plotNormalHistogram(breaky2$Follow.Up.Resting.Metabolic.Rate..kcal.d.)
# This is also close enough to skip transformation - yay!


  # Check for homogeneity of variance
leveneTest(repdat ~ Treatment.Group * contrasts, data = breaky5)
# Levene's Test for Homogeneity of Variance (center = median)
#       Df F value Pr(>F)
# group  3  1.0251  0.388
#       60 
  # Note: This p value above 0.05 validates the assumption - yay!


  # Confirm sample size (40, per 2 IV's)
View(breaky5)
# 66 entries, 7 total columns
  # Validated! Or so I thought... lesson says it's only 33 (ie: per test
    # sample size, I guess)... so I will ask about this on code review...
    # lesson also says to proceed in spite of violation, for the sake of
    # practice ;)



# Page 3 - Mixed Measures ANOVAs in R -----

# Run analysis
breakyMMAnova = aov(repdat ~ (Treatment.Group * contrasts) + 
                      Error(Participant.Code / contrasts), breaky5)

summary(breakyMMAnova)
# Error: Participant.Code
#                 Df Sum Sq Mean Sq
# Treatment.Group  1 154931  154931
# 
# Error: Participant.Code:contrasts
#           Df Sum Sq Mean Sq
# contrasts  1  717.2   717.2
# 
# Error: Within
#                           Df  Sum Sq Mean Sq F value Pr(>F)
# Treatment.Group            1      75      75   0.002  0.962
# contrasts                  1    5208    5208   0.154  0.696
# Treatment.Group:contrasts  1     921     921   0.027  0.869
# Residuals                 58 1956447   33732
  # Note: All 3 p values are above 0.05, which means we determined that there
    # is no significant impact on resting metabolic rate over time, whether
    # or not you eat breakfast; accept the null and reject the alternative 
    # hypothesis
      # Treatment.Group - p 0.962: impact on resting metabolic rate based on
        # whether or not subjects ate breakfast
      # contrasts - p 0.696: impact on resting metabolic rate over time
      # Treatment - p 0.869: impact on resting metabolic rate over time, 
        # based on whether or not subjects ate breakfast
          # NOTE: This last line is the "interaction effect"