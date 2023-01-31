# DSO105 - Intermediate Statistics
  # Lesson 7 - ANCOVAs
  # Page 5 - ANCOVA Activity

# Requirements: Using the graduate_admissions dataset, you will answer the 
  # question: "Does University Rating significantly predict your college GPA 
    # when holding TOEFL score constant?"
  # In order to do so, don't forget to:
    # -Test your assumptions and correct for them if necessary 
    # -Run the appropriate model type 
    # -Compute post hocs if faced with omnibus significance 
    # -Examine the means and draw conclusions to answer the question
  # Explain each step of the test and write your conclusions in your R script 
    # and attach it.
  # CV (continuous OR categorical): TOEFL
  # IV 1 (x axis, categorical): university rating
  # DV (y axis, continuous): CGPA
  # H0: University rating has no effect on CGPA, even when controlling for 
      # TOEFL scores
    # H1: University rating has an effect on CGPA, even when controlling for 
      # TOEFL scores


# Setup -----

  # Import packages
library(car)
library(dplyr)
library(effects)
library(IDPmisc)
library(multcomp)
library(psych)
library(rcompanion)


  # Import and preview data
cgpa = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 7. ANCOVAs/graduate_admissions.csv')

View(cgpa)
# 400 entries, 9 total columns
  # Note: Sample size assumption validated (for now)
    # CV: TOEFL.Score
    # IV: University.Rating
    # DV: CGPA



# Wrangling -----

  # Ensure IV is a factor
str(cgpa$University.Rating)
# Nope - need to update

    # Update data type
cgpa$University.Rating = as.factor(cgpa$University.Rating)

str(cgpa$University.Rating)
# Success - factor with 5 levels


  # Ensure CV is a factor
str(cgpa$TOEFL.Score)
# Nope - need to update

    # Update data type
cgpa$TOEFL.Score = as.factor(cgpa$TOEFL.Score)

str(cgpa$TOEFL.Score)
# Success - factor with 29 levels


# Test assumptions -----

  # Check for normal distribution
plotNormalHistogram(cgpa$CGPA)
# Doesn't get much better than this... but will double-check

    # Transform
cgpa$cgpaSqrd = (cgpa$CGPA ^ 2)

View(cgpa)
# 400 entries, 10 total columns


    # Check distribution again
plotNormalHistogram(cgpa$cgpaSqrd)
# Voila! Use this


  # Check for homogeneity of variance
leveneTest(cgpaSqrd ~ University.Rating, data = cgpa)
# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value Pr(>F)
# group   4  0.7201 0.5786
#       395
  # Note: This p value above 0.05 is not significant, which means this 
    # assumption has been validated


  # Check for homogeneity of regression slope
cgpaHomogRegres = lm(cgpaSqrd ~ TOEFL.Score, data = cgpa)

anova(cgpaHomogRegres)
# Analysis of Variance Table
# Response: cgpaSqrd
#              Df Sum Sq Mean Sq F value    Pr(>F)    
# TOEFL.Score  28  29810 1064.64  32.805 < 2.2e-16 ***
# Residuals   371  12040   32.45                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This p value is significant, which violates this assumption - which
    # means that a student's TOEFL score does predict their CGPA, which then 
    # means this would be an IV, not a CV
    # That said.. we'll proceed as if this was validated, instead


  # Check sample size (40, per IV and CV)
# Validated above



# Run analysis -----

  # ANCOVA when homogeneity of variance assumption was *validated*
cgpaAncova = lm(cgpaSqrd ~ TOEFL.Score + University.Rating * TOEFL.Score, 
                    data = cgpa)

anova(cgpaAncova)
# Analysis of Variance Table
# Response: cgpaSqrd
#                                Df  Sum Sq Mean Sq F value    Pr(>F)    
# TOEFL.Score                    28 29809.8 1064.64 37.5073 < 2.2e-16 ***
# University.Rating               4  2036.1  509.03 17.9333 2.932e-13 ***
# TOEFL.Score:University.Rating  57  1204.7   21.14  0.7446    0.9113    
# Residuals                     310  8799.3   28.38                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This test determined that there is a significant impact on a
    # student's CGPA based on their TOEFL score and their university rating, 
    # though not from the combined effect of TOEFL score and rating, though
    # not when CGPA will be high / low; reject the null and accept the 
    # alternative hypothesis
    # EXCEPT that this was just practice, and in reality we determined above
    # that the CV needs to be another IV instead



# Post hoc analysis -----
cgpaPostHoc = glht(cgpaAncova, linfct = mcp(University.Rating = 
                                                         'Tukey'))

summary(cgpaPostHoc)
# Can't figure out how to resolve this - will ask on code review:
  # Error in modelparm.default(model, ...) : 
  #   dimensions of coefficients and covariance matrix don't match
  # In addition: Warning message:
  # In mcp2matrix(model, linfct = linfct) :
  #   covariate interactions found -- default contrast might be inappropriate
# Note: Couldn't figure out yet, even on code review... the fun continues...


# Interpret results via means
cgpaAncova2 = lm(cgpaSqrd ~ TOEFL.Score + University.Rating, 
                      data = cgpa)
cgpaMeans = effect('University.Rating', cgpaAncova2)

cgpaMeans
#   University.Rating effect
#  University.Rating effect
# University.Rating
#        1        2        3        4        5 
# 68.05857 71.41676 73.87576 76.87338 79.88774 
  # Note: This test determined that, when corrected for TOEFL score (if the 
    # assumption of homogeneity of regression slopes had actually been 
    # validated), the higher the university rating, the significantly higher 
    # the CGPA - and vice versa
    # THAT SAID, this isn't confirmed yet since I could not yet successfully
    # run the post hoc analysis



# Summary -----
# This test determined that university rating has a significant effect on a
  # student's CGPA, even when controlling for their TOEFL score - the higher
  # rated their university, the higher their CGPA, and vice versa
  # THAT SAID, this isn't confirmed yet since I could not yet successfully
    # run the post hoc analysis