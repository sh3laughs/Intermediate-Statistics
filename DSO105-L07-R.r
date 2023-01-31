# DSO105 - Intermediate Statistics
  # Lesson 7 - ANCOVAs

# Page 3 - ANCOVA Set Up in R ------

  # From video

# Goal: Check for average price difference by staff member, while controlling 
  # for month
    # CV (continuous OR categorical): month
    # IV 1 (x axis, categorical): staff member
    # DV (y axis, continuous): average price
    # H0: Price is approx. the same for all staff members, even when 
        # controlling for month
      # H1: Price is different for different staff members, even when 
        # controlling for month

# Setup

  # Install new package
install.packages('effects')
install.packages('multcomp')
install.packages('psych')

  # Import packages
library(car)
library(dplyr)
library(effects)
library(IDPmisc)
library(multcomp)
library(psych)
library(rcompanion)

  # Import and preview data
salonCxl = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 7. ANCOVAs/client_cancellations.csv')

View(salonCxl)
# 243 entries, 11 total columns
  # Note: This validates the Sample Size assumption (for now)



# Covariate Exploration

  # Check effect of month
salonCxlMeans = salonCxl %>% group_by(cancel.date.month) %>% 
  summarise(monthMean = mean(avg.price))

View(salonCxlMeans)
# Need to remove NA's


  # Remove missing values
salonCxl2 = NaRV.omit(salonCxl)

View(salonCxl2)
# 241 entries, 11 total columns
  # Note: This still validates the Sample Size assumption


  # Check effect of month again
salonCxlMeans = salonCxl2 %>% group_by(cancel.date.month) %>% 
  summarise(avgPrcMean = mean(avg.price))

View(salonCxlMeans)
# Note: March seems noticeably higher than all other months


  # Dummy code month to use as CV (covariate)
salonCxl3 = dummy.code(salonCxl2$cancel.date.month)

View(salonCxl3)
# 0, 0, 0, 0, 1 (think: Flight of the Concords)


  # Convert to data frame and merge with original data
salonCxl4 = data.frame(salonCxl2, salonCxl3)

View(salonCxl4)
# 241 entries, 16 total columns



# Wrangling

  # View data types for IV and CV variables (both need to be factors)

    # IV
str(salonCxl4$staff)
# String - need to convert to factor

    # Convert to factor
salonCxl4$staff = as.factor(salonCxl4$staff)

str(salonCxl4$staff)
# Success - factor with 6 levels

    # CV
str(salonCxl4$March)
# Numeric - need to convert to factor

    # Convert to factor
salonCxl4$March = as.factor(salonCxl4$March)

str(salonCxl4$March)
# Success - factor with 2 levels



# Test assumptions

  # Check for normal distribution
plotNormalHistogram(salonCxl4$avg.price)
# Positively skewed

    # Transform
salonCxl4$avgPrcSqrt = sqrt(salonCxl4$avg.price)

View(salonCxl4)
# 241 entries, 17 total columns


    # Check distribution again
plotNormalHistogram(salonCxl4$avgPrcSqrt)
# Better! Use this


  # Check for homogeneity of variance
leveneTest(avgPrcSqrt ~ staff, data = salonCxl4)
# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value    Pr(>F)    
# group   5   6.132 2.319e-05 ***
#       235                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This p value found significance, which violates this assumption


  # Check for homogeneity of regression
salonCxlHomogenRegres = lm(avgPrcSqrt ~ March, data = salonCxl4)

anova(salonCxlHomogenRegres)
# Analysis of Variance Table
# Response: avgPrcSqrt
#            Df  Sum Sq Mean Sq F value Pr(>F)
# March       1    4.49  4.4905  0.7077 0.4011
# Residuals 239 1516.58  6.3455
  # Note: This p value over 0.05 validates this assumption


  # Check sample size (40, per IV and CV)
# Validated above



  # From lesson -----

# Goal: Controlling for students' research participation in undergrad, 
  # determine whether the rating of the students' undergraduate university 
  # impacts their chance of admittance into graduate school
    # CV (continuous OR categorical): research participation in undergrad
    # IV (x axis, categorical): rating of undergrad university
    # DV (y axis, continuous): admittance
    # H0: Students chances of grad school admittance are not effected by their
        # undergrad university's rating, even when controlling for their 
        # research participation
      # H1: Students chances of grad school admittance are effected by their
        # undergrad university's rating, even when controlling for their 
        # research participation

# Import and preview data
gradAdmit = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 7. ANCOVAs/graduate_admissions.csv')

View(gradAdmit)
# 400 entries, 9 total columns
  # Note: Sample size assumption validated (for now)
    # CV: Research
    # IV: University.Rating
    # DV: Chance.of.Admit


# Wrangling

  # Ensure IV is a factor
str(gradAdmit$University.Rating)
# Nope - need to update

    # Update data type
gradAdmit$University.Rating = as.factor(gradAdmit$University.Rating)

str(gradAdmit$University.Rating)
# Success - factor with 5 levels


  # Ensure CV is a factor
str(gradAdmit$Research)
# Nope - need to update

    # Update data type
gradAdmit$Research = as.factor(gradAdmit$Research)

str(gradAdmit$Research)
# Success - factor with 2 levels



# Test assumptions

  # Check for normal distribution
plotNormalHistogram(gradAdmit$Chance.of.Admit)
# Pretty good, actually, but may get better

    # Transform
gradAdmit$chncAdmitSqrd = (gradAdmit$Chance.of.Admit ^ 2)

View(gradAdmit)
# 400 entries, 10 total columns


    # Check distribution again
plotNormalHistogram(gradAdmit$chncAdmitSqrd)
# Voila! Use this


  # Check for homogeneity of variance
leveneTest(chncAdmitSqrd ~ University.Rating, data = gradAdmit)
# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value  Pr(>F)  
# group   4  2.4283 0.04734 *
#       395                  
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This p value under 0.05 is significant, which means this assumption
    # has been violated - will correct for this


  # Check for homogeneity of regression slope
gradAdmitHomogRegres = lm(chncAdmitSqrd ~ Research, data = gradAdmit)

anova(gradAdmitHomogRegres)
# Analysis of Variance Table
# Response: chncAdmitSqrd
#            Df  Sum Sq Mean Sq F value    Pr(>F)    
# Research    1  5.2035  5.2035   189.8 < 2.2e-16 ***
# Residuals 398 10.9113  0.0274                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This p value is significant, which violates this assumption - which
    # means that whether a not a student does undergrad research does impact 
    # their chance of grad school admittance, which then means this would be
    # an IV, not a CV
    # That said.. the lesson is having us ignore this ;)



# Page 4 - ANCOVAS in R -----

  # From video

# Run analysis

  # ANCOVA when homogeneity of variance assumption was *validated*
    # Note: This is just practice to learn how to handle this case, though 
      # in actuality this assumption was *violated*
salonCxlAncova = lm(avgPrcSqrt ~ March + staff * March, data = salonCxl4)

anova(salonCxlAncova)
# Analysis of Variance Table
# Response: avgPrcSqrt
#            Df  Sum Sq Mean Sq F value    Pr(>F)    
# March       1    4.49   4.490  0.8127    0.3683    
# staff       5  223.60  44.720  8.0933 4.624e-07 ***
# Residuals 234 1292.98   5.526                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: The only significance is for the IV - staff - indicating that who
    # the staff member is (still, per prior lesson's testing) still has a 
    # significant impact on price, even when controlling for the month
    # EXCEPT that this was just practice, and in reality we determined above
    # that the CV needs to be another IV instead AND the data failed the
    # assumption of homogeneity of variance


  # ANCOVA when homogeneity of variance assumption was *violated*
salonCxlAncova2 = lm(avgPrcSqrt ~ March + staff, data = salonCxl4)

Anova(salonCxlAncova2, white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# Response: avgPrcSqrt
#            Df       F    Pr(>F)    
# March       1 48.9272 2.766e-11 ***
# staff       5  5.5015 8.264e-05 ***
# Residuals 234                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This indicates that there is a significant impact on price based on
    # staff member (and month... which I think we knew since the assumption
    # of homogeneity of regression slopes was violated, which meant March 
    # should be an IV, not a DV), though we don't know high / low 
    # significance yet



# Post hoc analysis
salonCxlPostHoc = glht(salonCxlAncova2, linfct = mcp(staff = 'Tukey'))

summary(salonCxlPostHoc)
# 	 Simultaneous Tests for General Linear Hypotheses
# Multiple Comparisons of Means: Tukey Contrasts
# Fit: lm(formula = avgPrcSqrt ~ March + staff, data = salonCxl4)
# Linear Hypotheses:
#                      Estimate Std. Error t value Pr(>|t|)    
# JJ - BECKY == 0       1.02713    0.41750   2.460  0.12598    
# JOANNE - BECKY == 0   2.80754    0.46192   6.078  < 0.001 ***
# KELLY - BECKY == 0    0.92949    0.46493   1.999  0.32070    
# SINEAD - BECKY == 0   0.27971    0.61758   0.453  0.99724    
# TANYA - BECKY == 0   -0.16749    1.21325  -0.138  0.99999    
# JOANNE - JJ == 0      1.78041    0.45443   3.918  0.00133 ** 
# KELLY - JJ == 0      -0.09764    0.45749  -0.213  0.99993    
# SINEAD - JJ == 0     -0.74741    0.61200  -1.221  0.80991    
# TANYA - JJ == 0      -1.19462    1.21042  -0.987  0.91314    
# KELLY - JOANNE == 0  -1.87805    0.49837  -3.768  0.00250 ** 
# SINEAD - JOANNE == 0 -2.52782    0.64312  -3.931  0.00129 ** 
# TANYA - JOANNE == 0  -2.97503    1.22645  -2.426  0.13628    
# SINEAD - KELLY == 0  -0.64977    0.64529  -1.007  0.90608    
# TANYA - KELLY == 0   -1.09698    1.22759  -0.894  0.94165    
# TANYA - SINEAD == 0  -0.44720    1.29314  -0.346  0.99925    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# (Adjusted p values reported -- single-step method)
  # Note: (If these results were valid, which they are not since the CV 
    # should have been updated to an IV) This shows that there is a 
    # significant price difference between Joanne and each of Becky, JJ, 
    # Kelly, and Sinead - even when it is not March ('== 0' in the results
    # indicate that March, as the CV, has been excluded from the values
    # included in the analysis for each level of the IV), though we don't 
    # know from these results, whose prices are higher / lower; reject the null 
    # and accept the alternative hypothesis



# Interpret results via means
salonCxlAncova3 = lm(avg.price ~ March + staff, data = salonCxl4)
salonCxlMeans = effect('staff', salonCxlAncova3)

salonCxlMeans
#  staff effect
# staff
#     BECKY        JJ    JOANNE     KELLY    SINEAD     TANYA 
#  51.25367  65.84454 108.23153  66.32681  52.92277  52.41158
  # Note: As with test in prior lesson, this test determined that, even
    # when corrected for the month of March (if the assumption of homogeneity
    # of regression slopes had actually been validated), Joanne's prices are
    # significantly higher than the other staff members



  # From lesson

# Run analysis

  # ANCOVA when homogeneity of variance assumption was *validated*
    # Note: This is just practice to learn how to handle this case, though 
      # in actuality this assumption was *violated*
gradAdmitAncova = lm(chncAdmitSqrd ~ Research + University.Rating * Research, 
                    data = gradAdmit)

anova(gradAdmitAncova)
# Analysis of Variance Table
# Response: chncAdmitSqrd
#                             Df Sum Sq Mean Sq  F value    Pr(>F)    
# Research                     1 5.2035  5.2035 349.7108 < 2.2e-16 ***
# University.Rating            4 4.7389  1.1847  79.6203 < 2.2e-16 ***
# Research:University.Rating   4 0.3694  0.0923   6.2063 7.527e-05 ***
# Residuals                  390 5.8030  0.0149                       
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This test determined that there is a significant impact on an
    # undergrad student's chances of being accepted to grad school based on
    # whether or not they did undergrad research, by the university rating, 
    # as well as the combined effect of research and rating...
    # EXCEPT that this was just practice, and in reality we determined above
    # that the CV needs to be another IV instead AND the data failed the
    # assumption of homogeneity of variance


  # ANCOVA when homogeneity of variance assumption was *violated*
gradAdmitAncova2 = lm(chncAdmitSqrd ~ Research + University.Rating, 
                      data = gradAdmit)

Anova(gradAdmitAncova2, white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# Response: chncAdmitSqrd
#                    Df      F    Pr(>F)    
# Research            1 52.008  2.85e-12 ***
# University.Rating   4 68.996 < 2.2e-16 ***
# Residuals         394                     
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This test determined that there is a significant impact on an
    # undergrad student's chances of being accepted to grad school based on
    # whether or not they did undergrad research, by the university rating, 
    # as well as the combined effect of research and rating...
    # EXCEPT that this was just practice, and in reality we determined above
    # that the CV needs to be another IV instead



# Post hoc analysis
gradAdmitPostHoc = glht(gradAdmitAncova2, linfct = mcp(University.Rating = 
                                                         'Tukey'))

summary(gradAdmitPostHoc)
# 	 Simultaneous Tests for General Linear Hypotheses
# Multiple Comparisons of Means: Tukey Contrasts
# Fit: lm(formula = chncAdmitSqrd ~ Research + 
          # University.Rating, data = gradAdmit)
# Linear Hypotheses:
#            Estimate Std. Error t value Pr(>|t|)    
# 2 - 1 == 0  0.08335    0.02741   3.041   0.0198 *  
# 3 - 1 == 0  0.16684    0.02727   6.118   <0.001 ***
# 4 - 1 == 0  0.30099    0.02979  10.105   <0.001 ***
# 5 - 1 == 0  0.40552    0.03089  13.126   <0.001 ***
# 3 - 2 == 0  0.08349    0.01659   5.033   <0.001 ***
# 4 - 2 == 0  0.21764    0.02019  10.779   <0.001 ***
# 5 - 2 == 0  0.32217    0.02172  14.832   <0.001 ***
# 4 - 3 == 0  0.13415    0.01853   7.240   <0.001 ***
# 5 - 3 == 0  0.23868    0.02003  11.919   <0.001 ***
# 5 - 4 == 0  0.10453    0.02177   4.802   <0.001 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# (Adjusted p values reported -- single-step method)
  # Note: (If these results were valid, which they are not since the CV 
    # should have been updated to an IV) This shows that there is a 
    # significant impact on chances of admittance to grad school for all
    # university ratings ('== 0' in the results indicate that Research, as 
    # the CV, has been excluded from the values included in the analysis for 
    # each level of the IV), as well as a significant difference in what this
    # impact is between all ratings and each other, though we don't know from 
    # these results, which ratings yield higher / lower chances for admittance; 
    # reject the null and accept the alternative hypothesis



# Interpret results via means
gradAdmitAncova3 = lm(chncAdmitSqrd ~ Research + University.Rating, 
                      data = gradAdmit)
gradAdmitMeans = effect('University.Rating', gradAdmitAncova3)

gradAdmitMeans
#   University.Rating effect
# University.Rating
#         1         2         3         4         5 
# 0.3506859 0.4340377 0.5175279 0.6516802 0.7562066 
  # Note: This test determined that, when corrected for research (if the 
    # assumption of homogeneity of regression slopes had actually been 
    # validated), the higher the university rating, the significantly higher 
    # chance of admittance to grad school - and vice versa