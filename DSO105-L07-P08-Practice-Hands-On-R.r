# DSO105 - Intermediate Statistics
  # Lesson 7 - ANCOVAs
  # Page 8 - ANCOVA in R Practice Hands-On

# Requirements: This hands on uses a dataset on cell phone plans. It is 
    # located here.
  # Please answer the following question with this data:
    # Many folks with international relatives often find themselves calling 
      # at odd hours to fit typical schedules in other time zones. How does 
      # the presence or absence of an international phone plan 
      # (International.Plan) influence the use of nighttime minutes 
      # (Night.Mins), holding whether or not the client has a voicemail plan 
      # (vMail.Plan) constant?
  # In order to answer this question, you will need to do the following:
    # Test for ANCOVA assumptions
    # Run an ANCOVA
    # Interpret the ANCOVA results and draw conclusions
    # Conduct post hocs if necessary
  # Please submit your R studio file, with a one-sentence conclusion to 
    # answer the above question.
  # CV (continuous OR categorical): VM plan
  # IV 1 (x axis, categorical): international plan
  # DV (y axis, continuous): night time minutes
  # H0: An international plan has no effect on nigh time minutes, even when 
      # controlling for a VM plan
    # H1: An international plan has an effect on nigh time minutes, even when 
      # controlling for a VM plan


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
cellPhone = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 7. ANCOVAs/cellPhone.csv')

View(cellPhone)
# 4,617 entries, 21 total columns
  # Note: Sample size assumption validated (for now)
    # CV: vMail.Plan
    # IV: International.Plan
    # DV: Night.Mins



# Covariate Exploration -----

  # Check effect of voicemail plan
cellPhoneMeans = cellPhone %>% group_by(vMail.Plan) %>% 
  summarise(nightMinMeans = mean(Night.Mins))

View(cellPhoneMeans)
# Seems like a very small difference... we'll see...



# Wrangling -----

  # Ensure IV is a factor
str(cellPhone$International.Plan)
# Nope - need to update

    # Update data type
cellPhone$International.Plan = as.factor(cellPhone$International.Plan)

str(cellPhone$International.Plan)
# Success - factor with 2 levels


  # Ensure CV is a factor
str(cellPhone$vMail.Plan)
# Nope - need to update

    # Update data type
cellPhone$vMail.Plan = as.factor(cellPhone$vMail.Plan)

str(cellPhone$vMail.Plan)
# Success - factor with 2 levels


    # Dummy code month to use as CV (covariate)
cellPhone1 = dummy.code(cellPhone$vMail.Plan)

View(cellPhone1)
# 0, 0, 0, 0, 1 (think: Flight of the Concords)


    # Convert to data frame and merge with original data
cellPhone2 = data.frame(cellPhone, cellPhone1)

View(cellPhone2)
# 4,617 entries, 23 total columns



# Test assumptions -----

  # Check for normal distribution
plotNormalHistogram(cellPhone$Night.Mins)
# So close to perfect - will use this



  # Check for homogeneity of variance
leveneTest(Night.Mins ~ International.Plan, data = cellPhone2)
# Levene's Test for Homogeneity of Variance (center = median)
#         Df F value Pr(>F)
# group    1  0.8646 0.3525
#       4615 
  # Note: This p value above 0.05 is not significant, which means this 
    # assumption has been validated


  # Check for homogeneity of regression slope
cellPhoneHomogRegres = lm(Night.Mins ~ vMail.Plan, data = cellPhone)

anova(cellPhoneHomogRegres)
# Analysis of Variance Table
# Response: Night.Mins
#              Df   Sum Sq Mean Sq F value Pr(>F)
# vMail.Plan    1      488  487.73  0.1909 0.6622
# Residuals  4615 11791809 2555.10
  # Note: This p value is not significant, which validates this assumption


  # Check sample size (40, per IV and CV)
# Validated above



# Run analysis -----

  # ANCOVA when homogeneity of variance assumption was *validated*
cellPhoneAncova = lm(Night.Mins ~ vMail.Plan + International.Plan * 
                       vMail.Plan, data = cellPhone2)

anova(cellPhoneAncova)
# Analysis of Variance Table
# Response: Night.Mins
#                                 Df   Sum Sq Mean Sq F value  Pr(>F)  
# vMail.Plan                       1      488   487.7  0.1909 0.66216  
# International.Plan               1     7979  7978.6  3.1235 0.07724 .
# vMail.Plan:International.Plan    1      435   435.0  0.1703 0.67989  
# Residuals                     4613 11783396  2554.4                  
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This test determined that there is a significant impact on how many
    # night time minutes are used based on whether or not the cell phone
    # account holder has an international plan, and no significant impact 
    # based on wehther or not they have a voicemail plan - or from the 
    # interaction of whether or not they have both international and VM plans
    # or only one or the other... it does not indicate high / low data



# Post hoc analysis -----
cellPhonePostHoc = glht(cellPhoneAncova, linfct = mcp(International.Plan = 
                                                         'Tukey'))

summary(cellPhonePostHoc)
# 	 Simultaneous Tests for General Linear Hypotheses
# Multiple Comparisons of Means: Tukey Contrasts
# Fit: lm(formula = Night.Mins ~ vMail.Plan + International.Plan * vMail.Plan, 
#     data = cellPhone2)
# Linear Hypotheses:
#                 Estimate Std. Error t value Pr(>|t|)  
#  yes -  no == 0   -5.096      2.965  -1.719   0.0857 .
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# (Adjusted p values reported -- single-step method)
  # Note: This determined that there is no significance, after all, on the
    # number of night time minutes used based on whether or not there is an
    # international plan; accept the null and reject the alternative hypothesis
    # That said, for practice, I will compare means


# Interpret results via means
cellPhoneAncova2 = lm(Night.Mins ~ vMail.Plan + International.Plan, 
                      data = cellPhone)
cellPhoneMeans = effect('International.Plan', cellPhoneAncova2)

cellPhoneMeans
#  International.Plan effect
# International.Plan
#       no      yes 
# 201.0538 196.6037 
  # Note: This appears to validate that there is no significant impact on
    # the number of night time minutes used based on whether or not there is
    # an international plan



# Summary -----
# This test determined that cell phone account holders tend to use the same
  # number of night time minutes, regardless of whether or not they have an 
  # international plan, even when controlling for whether or not they have a 
  # voice mail plan