# DSO105 - Intermediate Statistics
  # Lesson 5 - Repeated Measures ANOVAs

# Page 2 - Repeated Measures ANOVAs Setup in R -----

# Install new package
install.packages('fastR2')

# Import packages
library(car)
library(dplyr)
library(fastR2)
library(rcompanion)

# Import data
metabRate = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 5. Repeated Measures ANOVAs/breakfast.csv')

View(metabRate)
# 150 entries, 141 total columns
  # Note: Rows 34 and below are NA's... also.. this is a LOT of columns!
    # Also noteworthy - this (pre-transformed, if necessary) validates the 
    # sample size assumption

# Question: Overall, regardless of whether participants ate breakfast or not, 
  # did people in this study show improvement in their resting metabolic rate?   
    # H0: People in this study showed no improvement
      # H1: People in this study showed improvement

# Wrangling

  # Remove NA's via saving only rows with values
metabRate1 = metabRate[1:33,]

View(metabRate1)
# 33 entries, 141 total columns
  # Note: Big difference!


  # Reshape data to be long (instead of wide)

    # Subset to only include defined columns
metabRateKeep = c('Participant.Code', 'Treatment.Group', 'Age..y.', 'Sex',
               'Height..m.', 'Baseline.Resting.Metabolic.Rate..kcal.d.', 
               'Follow.Up.Resting.Metabolic.Rate..kcal.d.')
metabRate2 <- metabRate1[metabRateKeep]

View(metabRate2)
# 33 entries, 7 total columns


  # Baseline data - keep first 5 columns of subset data, with baseline
    # resting metabolic rate renamed as 'repdat' and all data assigned
    # 'T1' (test 1) in a new 'contrasts' column (contrasts between baseline 
    # and follow-up data)
metabRate3 = metabRate2[, 1:5]
metabRate3$repdat = metabRate2$Baseline.Resting.Metabolic.Rate..kcal.d.
metabRate3$contrasts = 'T1'

View(metabRate3)
# 33 entries, 7 total columns


  # Follow-up data - keep first 5 columns of subset data, with follow-up
    # resting metabolic rate renamed as 'repdat' (data that was repeated) 
    # and all data assigned 'T2' (test 2) in a new 'contrasts' column 
    # (contrasts between baseline and follow-up data)
metabRate4 = metabRate2[, 1:5]
metabRate4$repdat = metabRate2$Follow.Up.Resting.Metabolic.Rate..kcal.d.
metabRate4$contrasts = 'T2'

View(metabRate4)
# 33 entries, 7 total columns


  # Re-merge baseline and follow-up data
metabRate5 = rbind(metabRate3, metabRate4)

View(metabRate5)
# 66 entries, 7 total columns
  # Success! Data is reshaped ;)
  # IV (x axis, categorical / time): contrasts
  # DV (y axis, continuous): repdat


# Test assumptions

  # Check for normal distribution - on pre-reshaped data, to ensure
    # baseline and follow-up data are taken into account separately

    # Baseline
plotNormalHistogram(metabRate2$Baseline.Resting.Metabolic.Rate..kcal.d.)
# It's not perfect, but close enough! Woo hoo!

  # Follow-up
plotNormalHistogram(metabRate2$Follow.Up.Resting.Metabolic.Rate..kcal.d.)
# This is also close enough to skip transformation - yay!


  # Check for homogeneity of variance
leveneTest(repdat ~ contrasts, data = metabRate5)
# Levene's Test for Homogeneity of Variance (center = median)
#       Df F value Pr(>F)
# group  3  1.0251  0.388
#       60
  # Note: This p value above 0.05 validates the assumption - yay!


  # Confirm sample size (40, per 2 IV's)
View(metabRate5)
# 66 entries, 7 total columns
  # Validated!


  # Check for sphericity.. to be learned later ;)



# Page 3 - Repeated Measures ANOVAs in R -----

  # From video -----
    # Note: This video is part 2, part 1 video is missing :/ some of the
      # code from that video is in this one, so I'm starting with that in
      # hopes of it working out

# Goal: Determine whether coup risk changes over time
  # IV (x axis, categorical / time): year
  # DV (y axis, continuous): coup risk
  # H0: Coup risk does not change over time
    # H1: Coup risk changes over time


# Import data
coupRisk = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 6. Mixed Measures ANOVAs/coup_risk.csv')

View(coupRisk)
# 13,048 entries, 45 total columns


# Wrangling

  # Update data type for date column & create new column for year
coupRisk$date = as.Date(coupRisk$date, '%m/%d/%Y')
coupRisk$year = format(coupRisk$date, '%Y')

str(coupRisk)
# 13048 obs. of  46 variables
  # Date column is date format
  # (New) year column is string format


# Test assumptions

  # Check for normal distribution
plotNormalHistogram(coupRisk$couprisk)
# Positively skewed

    # Transform
coupRisk$coupriskSqrt = sqrt(coupRisk$couprisk)

View(coupRisk)
# 13,048 entries, 47 total columns


    # Check distribution again
plotNormalHistogram(coupRisk$coupriskSqrt)
# Better, but still skewed

    # Transform again
coupRisk$coupriskLog = log(coupRisk$couprisk)

View(coupRisk)
# 13,048 entries, 48 total columns


    # Check distribution again
plotNormalHistogram(coupRisk$coupriskLog)
# Much better - use this


  # Check for homogeneity of variance
leveneTest(couprisk ~ country_name * year, data = coupRisk)
# Levene's Test for Homogeneity of Variance (center = median)
#          Df F value    Pr(>F)    
# group  1111  6.2005 < 2.2e-16 ***
#       11925                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This found significance, which means the assumption was violated
    # and the data are heterogeneic


  # Confirm sample size
View(coupRisk)
# 13,048 entries, 48 total columns
  # Note: Validated


# Run analysis
coupRiskRMAnova = aov(couprisk ~ year + Error(country_name), coupRisk)

summary(coupRiskRMAnova)
# Error: country_name
# Df  Sum Sq  Mean Sq F value Pr(>F)  
# year      22 0.05205 0.002366   2.146 0.0319 *
#   Residuals 26 0.02867 0.001103                 
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# Error: Within
# Df  Sum Sq   Mean Sq F value Pr(>F)    
# year         22 0.01635 0.0007433   50.91 <2e-16 ***
#   Residuals 12966 0.18931 0.0000146                   
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This found significance - though we don't know if it is high
    # or low (I also don't know yet if the data having heterogeneic variance 
    # means these results are not usable...); reject the null and accept the 
    # alternative hypothesis


# Interpret results

  # Find means
coupRiskMeans = coupRisk %>% 
  group_by(year) %>% summarise(coupriskMean = mean(couprisk))

View(coupRiskMeans)
# While there is variation, overall the means get smaller over time,
  # which mean the risk of a coup has gone down over time


  # From lesson -----

# Run analysis
metabRateRMAnova <- aov(repdat ~ contrasts + Error(Participant.Code), metabRate5)

summary(metabRateRMAnova)
# Error: Participant.Code
# Df Sum Sq Mean Sq F value Pr(>F)
# Residuals  1 154931  154931               
# 
# Error: Within
# Df  Sum Sq Mean Sq F value Pr(>F)
# contrasts  1     276     276   0.009  0.926
# Residuals 61 1963092   32182  
  # Note: This p value under 0.05 determined that there is a significant
    # difference in resting metabolic rate over time; reject the null and 
    # accept the alternative hypothesis
  # ALSO, this lesson was all sorts of messed up - including the provided
    # code for this analysis including an extra IV that was not relevant to
    # the goal of the analysis... so these results are different from what
    # was in the lesson content - because my analysis was significant, I will
    # proceed to interpretation


# Interpret results

  # Find means
metabRateMeans = metabRate5 %>% 
  group_by(contrasts) %>% summarise(repdatMean = mean(repdat))

View(metabRateMeans)
# Oops, need to drop NA's first

    # Drop missing values
library(IDPmisc)
metabRate6 = NaRV.omit(metabRate5)

    # Find means
metabRateMeans = metabRate6 %>% 
  group_by(contrasts) %>% summarise(repdatMean = mean(repdat))

View(metabRateMeans)
# This determines that the baseline resting metabolic rate (1452.406) is 
  # significantly lower than the follow-up rate (1456.562)