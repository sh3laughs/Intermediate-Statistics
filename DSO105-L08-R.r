# DSO105 - Intermediate Statistics
  # Lesson 8 - MANOVAs

# Page 3 - MANOVA Preparation in R -----

  # From video

# Goal: Determine whether or not staff member impacts price and / or the day
  # of the cancellation
    # IV 1 (x axis, categorical): staff member
    # DV1 (y axis, continuous): average price
    # DV2 (y axis, continuous): days in advance
    # H0: Price and day do not change by staff member
      # H1: Price and/ or day are different for different staff members

# Install package
install.packages('mvnormtest')

# Import packages
library(car)
library(IDPmisc)
library(mvnormtest)

# Import and preview data
salonCxlAgain = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/client_cancellations.csv')

View(salonCxlAgain)
# 243 entries, 11 total columns


# Wrangling

  # Confirm both DV's are numeric
str(salonCxlAgain)
# Yay! They both are

  # Remove missing values
salonCxlAgain2 = NaRV.omit(salonCxlAgain)

View(salonCxlAgain2)
# 241 entries, 11 total columns


  # Subset to only include DV's and format as matrix
salonCxlKeeps = c('days.in.adv', 'avg.price')
salonCxlAgain3 = salonCxlAgain2[salonCxlKeeps]
salonCxlAgain4 = as.matrix(salonCxlAgain3)

View(salonCxlAgain4)
# 241 entries, 2 total columns



# Test assumptions

  # Check for multivariate normality
mshapiro.test(t(salonCxlAgain4))
# 	Shapiro-Wilk normality test
# data:  Z
# W = 0.55738, p-value < 2.2e-16
  # Note: This found significance, which means this assumption is violated,
    # and a MANOVA should not be run
    # ...but we're going forward anyway, for practice 


  # Check for homogeneity of variance for each DV

    # Days in advance
leveneTest(days.in.adv ~ staff, data = salonCxl)
# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value Pr(>F)
# group   5  0.7968 0.5529
#       237
  # Note: Assumption validated - yay!

    # Average price
leveneTest(avg.price ~ staff, data = salonCxlAgain)
# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value    Pr(>F)    
# group   5  9.8315 1.509e-08 ***
#       235                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: Unfortunately this IV violates the assumption - which means
    # the assumption is violated for the whole test
    # ... but, as with everything in this module, we'll proceed anyway


  # Check for absence of multicollinearity
cor.test(salonCxlAgain$days.in.adv ~ salonCxlAgain$avg.price, 
         method = 'pearson', use = 'complete.obs')
# 	Pearson's product-moment correlation
# data:  salonCxlAgain$days.in.adv and salonCxlAgain$avg.price
# t = -1.2739, df = 239, p-value = 0.2039
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  -0.20634802  0.04470744
# sample estimates:
#         cor 
# -0.08212297
  # Note: There is a tiny correlation between the DV's - well below 70%, 
    # which validates this assumption
    # Any applicable correlation test can be used for this assumption



  # From lesson

# Goal: Determine whether the country a project originated in influences the 
  # number of backers and/ or the amount of money pledged?
    # IV 1 (x axis, categorical): country
    # DV1 (y axis, continuous): number of backers
    # DV2 (y axis, continuous): amount of money pledged
    # H0: Country has no effect on backers or money pledged
      # H1: Country has an effect on backers and/ or money pledged

# Import and preview data
kickS = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 8. MANOVAs/kickstarter.csv')

View(kickS)
# 323,750 entries, 17 total columns
  # A lotta data!


# Wrangling

  # Ensure DV's are numeric
str(kickS)
# Both are string...

    # Convert both DV's
kickS$pledged = as.numeric(kickS$pledged)
kickS$backers = as.numeric(kickS$backers)

str(kickS)
# Success


  # Subset DV's into a new variable to check for multivariate normality
    # and reduce # of rows
kickSKeeps = c('pledged', 'backers')
kickS1 = kickS[kickSKeeps]
kickS2 = kickS1[1:5000,]

View(kickS2)
# 5,000 entries, 2 total columns



# Test assumptions

  # Sample size
    # Note: lesson says this is validated, so I'm not yet sure how to check
      # for it, when needed

  # Check for multivariate normality
kickS3 = NaRV.omit(kickS2)

mshapiro.test(t(kickS3))
# 	Shapiro-Wilk normality test
# data:  Z
# W = 0.07914, p-value < 2.2e-16
  # Note: This is significant, which violates this assumption, so a MANOVA
    # should not be run
    # As with video, we'll proceed anyway...


  # Check for homogeneity of variance

    # Pledged DV
leveneTest(kickS$pledged, kickS$country, data = kickS)
# Levene's Test for Homogeneity of Variance (center = median: kickS)
#           Df F value    Pr(>F)    
# group     23  22.131 < 2.2e-16 ***
#       323102                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This is significant, which violates this assumption
    # And yet the show goes on...

    # Backers DV
leveneTest(kickS$backers, kickS$country, data = kickS)
# Levene's Test for Homogeneity of Variance (center = median: kickS)
#           Df F value    Pr(>F)    
# group     24   189.2 < 2.2e-16 ***
#       323102                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This is also significant, which also violates this assumption
    # And yet the show goes on...


  # Check for absence of multicollinearity
cor.test(kickS$pledged, kickS$backers, method = 'pearson', 
         use = 'complete.obs')
# 	Pearson's product-moment correlation
# data:  x and y
# t = 615.89, df = 323124, p-value < 2.2e-16
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.7332546 0.7364268
# sample estimates:
#       cor 
# 0.7348447 
  # Note: These DV's are significantly correlated... which violates this 
    # assumption
    # NOTE: These are different results from the lesson, and I'm not sure why
    # ... other than the fact that this module is fraught with errors...



# Page 4 - MANOVAS in R -----

  # From video

# Run analysis
salonCxlAgainManova = manova(cbind(days.in.adv, avg.price) ~ staff,
                             data = salonCxlAgain)

summary(salonCxlAgainManova)
#            Df Pillai approx F num Df den Df    Pr(>F)    
# staff       5 0.2471   6.6253     10    470 1.215e-09 ***
# Residuals 235                                            
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: (If assumptions had been validated, not violated) This indicates 
    # that staff does influence price and days in advance for cancellations - 
    # not yet whether one has price of timing are more significant



# Post hoc analysis

  # Anova
summary.aov(salonCxlAgainManova, test = 'wilks')
#  Response days.in.adv :
#              Df  Sum Sq Mean Sq F value Pr(>F)
# staff         5   489.4  97.871  0.9081 0.4764
# Residuals   235 25327.5 107.776               
#  Response avg.price :
#              Df Sum Sq Mean Sq F value    Pr(>F)    
# staff         5  95215 19042.9   14.24 3.553e-12 ***
# Residuals   235 314254  1337.2                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 2 observations deleted due to missingness
  # Note: (If assumptions had been validated, not violated) Impact on days in 
    # advance is not significant, but average price is - so the price was what 
    # determined significance - we don't know high / low; reject the null and 
    # accept the alternative hypothesis

  # T-test on significant DV
pairwise.t.test(salonCxlAgain$avg.price, salonCxlAgain$staff, 
                p.adjust = 'bonferroni')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  salonCxlAgain$avg.price and salonCxlAgain$staff 
#        BECKY   JJ      JOANNE  KELLY SINEAD
# JJ     0.282   -       -       -     -     
# JOANNE 1.3e-12 1.6e-07 -       -     -     
# KELLY  0.574   1.000   2.4e-06 -     -     
# SINEAD 1.000   1.000   1.3e-06 1.000 -     
# TANYA  1.000   1.000   0.057   1.000 1.000 
# P value adjustment method: bonferroni
  # Note: (If assumptions had been validated, not violated) Joanne's prices 
    # are significantly different than everyone else's, though we don't know
    # high/ low



# Interpret results

  # Find means
salonCxlAgainMeans = salonCxlAgain2 %>% group_by(staff) %>% 
  summarise(avgPrcMeans = mean(avg.price)) %>% arrange(desc(avgPrcMeans))

View(salonCxlAgainMeans)
# Note: (If assumptions had been validated, not violated) Joanne's prices are 
  # significantly higher than all other staff members'



  # From lesson

# Run analysis
kickSManova = manova(cbind(backers, pledged) ~ country, data = kickS)

summary(kickSManova)
#               Df   Pillai approx F num Df den Df    Pr(>F)    
# country       23 0.032996   235.65     46 646204 < 2.2e-16 ***
# Residuals 323102                                              
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: (If assumptions had been validated, not violated) This indicates 
    # that country does influence backers and how much is pledged



# Post hoc analysis

  # Anova
summary.aov(kickSManova, test = 'wilks')
#  Response backers :
#                 Df     Sum Sq   Mean Sq F value    Pr(>F)    
# country         23 4.0433e+09 175796074  198.45 < 2.2e-16 ***
# Residuals   323102 2.8622e+11    885848                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
#  Response pledged :
#                 Df     Sum Sq    Mean Sq F value    Pr(>F)    
# country         23 4.1367e+12 1.7985e+11  22.445 < 2.2e-16 ***
# Residuals   323102 2.5891e+15 8.0133e+09                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 624 observations deleted due to missingness
  # Note: (If assumptions had been validated, not violated) This indicates
    # that country impacts both the # of backers and how much is pledged
    # though we don't know how (high/ low) either are influenced; reject the 
    # null and accept the alternative hypothesis


  # T-test on significant DV1
pairwise.t.test(kickS$backers, kickS$country, p.adjust = 'bonferroni')
# Note: This output was different than I've seen so far, and this step was
  # not included in lesson, so I'm not sure how to interpret

  # T-test on significant DV2
pairwise.t.test(kickS$pledged, kickS$country, p.adjust = 'bonferroni')
# Note: This output was different than I've seen so far, and this step was
  # not included in lesson, so I'm not sure how to interpret



# Interpret results

  # Find means for DV1
kickSMeans = kickS %>% group_by(country) %>% 
  summarise(backMeans = mean(backers)) %>% arrange(desc(backMeans))

View(kickSMeans)
# Note: Aaah, no wonder the t test results were hard to decipher - the levels
  # for the country variable are a mess... stopping here, since lesson didn't
  # cover any of this