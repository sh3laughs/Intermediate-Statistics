# DSO105 - Intermediate Statistics
  # Lesson 8 - MANOVAs
  # Page 6 - MANOVA in R Hands-On

# Requirements: This hands on uses a dataset that can predict heart attacks. It 
    # is located here.
  # Please answer the following question with this data:
   # It is well-known that men are more likely to have heart attacks than 
    # women. How does gender (sex) influence some of the heart attack 
    # predictors like resting blood pressure (trestbps) and cholesterol (chol)?
  # In order to do so, you will need to do the following:
    # Test for MANOVA assumptions
    # Run a MANOVA
  # Don't worry about correcting for any violations you may encounter, since 
    # you have not yet been taught how to overcome them.
  # Please submit your R studio file, with a one-sentence conclusion to answer 
    # the above question in the comments.
  # IV 1 (x axis, categorical): gender
  # DV1 (y axis, continuous): resting blood pressure
  # DV2 (y axis, continuous): cholesterol
  # H0: Gender has no effect on resting blood pressure or cholesterol
    # H1: Gender has an effect on resting blood pressure and/ or cholesterol


# Setup -----

# Import packages
library(car)
library(IDPmisc)
library(mvnormtest)

# Import and preview data
heartAttax = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 8. MANOVAs/heartAttacks.csv')

View(heartAttax)
# 303 entries, 14 total columns
  # Note: I *think* this validates sample size.. but we haven't actually been
    # taught how to test for that for a MANOVA, so I'm not yet confident...
  # IV 1 (x axis, categorical): sex
  # DV1 (y axis, continuous): trestbps
  # DV2 (y axis, continuous): chol


# Exploration & wrangling -----

  # Confirm both DV's are numeric and IV is not
str(heartAttax)
# Both DV's are numeric, but so is IV

    # Update data type for IV
heartAttax$sex = as.character(heartAttax$sex)

str(heartAttax)
# Success


  # Confirm whether there are any missing values
sum(is.na(heartAttax))
# Nope! Nice


  # Subset to only include DV's and format as matrix
heartAttaxKeeps = c('trestbps', 'chol')
heartAttax2 = heartAttax[heartAttaxKeeps]
heartAttax3 = as.matrix(heartAttax2)

View(heartAttax3)
# 303 entries, 2 total columns



# Test assumptions -----

  # Check for multivariate normality
mshapiro.test(t(heartAttax3))
# 	Shapiro-Wilk normality test
# data:  Z
# W = 0.94568, p-value = 3.93e-09
  # Note: This found significance, which means this assumption is violated,
    # and a MANOVA should not be run
    # But requirements say to ignore this...


  # Check for homogeneity of variance for each DV

    # Resting blood pressure
leveneTest(trestbps ~ sex, data = heartAttax)
# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value Pr(>F)
# group   1  1.3593 0.2446
#       301
  # Note: Assumption validated - yay!

    # Cholesterol
leveneTest(chol ~ sex, data = heartAttax)
# Levene's Test for Homogeneity of Variance (center = median)
#        Df F value    Pr(>F)    
# group   1  11.376 0.0008413 ***
#       301                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: Significant p value violates this assumption
    # But requirements say to ignore this...


  # Check for absence of multicollinearity
cor.test(heartAttax$trestbps ~ heartAttax$chol, method = 'pearson', 
         use = 'complete.obs')
# 	Pearson's product-moment correlation
# data:  heartAttax$trestbps and heartAttax$chol
# t = 2.1534, df = 301, p-value = 0.03208
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.01064389 0.23262366
# sample estimates:
#       cor 
# 0.1231742
  # Note: Significant p value violates this assumption
    # But requirements say to ignore this...


  # Confirm sample size
# Note: Per above we have 303 rows, so I *think* this has been validated, but
  # we were not actually taught how to test for this for MANOVAs



# Run analysis -----
heartAttaxManova = manova(cbind(trestbps, chol) ~ sex, data = heartAttax)

summary(heartAttaxManova)
#            Df   Pillai approx F num Df den Df   Pr(>F)   
# sex         1 0.040235   6.2882      2    300 0.002112 **
# Residuals 301                                            
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: (If assumptions had been validated, not violated) This indicates 
    # that gender does impact resting blood pressure and cholestoral - though
    # without indicating if one or the other are more significant, nor 
    # whether impact is high / low



# Post hoc analysis -----

  # Anova
summary.aov(heartAttaxManova, test = 'wilks')
#  Response trestbps :
#              Df Sum Sq Mean Sq F value Pr(>F)
# sex           1    299  299.36  0.9732 0.3247
# Residuals   301  92592  307.61               
# 
#  Response chol :
#              Df Sum Sq Mean Sq F value  Pr(>F)    
# sex           1  31778   31778  12.271 0.00053 ***
# Residuals   301 779523    2590                    
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: (If assumptions had been validated, not violated) Impact on  
    # cholesterol is not significant, but resting blood pressure is - so the 
    # latter was what determined significance - we don't know high / low

  # T-test on significant DV
pairwise.t.test(heartAttax$trestbps, heartAttax$sex, p.adjust = 'bonferroni')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  heartAttax$trestbps and heartAttax$sex
#   0   
# 1 0.32
# P value adjustment method: bonferroni
  # Note: (If assumptions had been validated, not violated) This indicates
    # there is no significance, after all - or possibly that the significant
    # impact of gender on resting blood pressure only exists when cholesterol
    # is also impacted; accept the null and reject the alternative hypothesis... 
    # OR that this t test is the wrong next step in analysis.. as it was only a 
    # guess to do it based on a comment in video, though no actually coverage 
    # of this in the lesson... I'll go ahead and review means as if all of this 
    # had gone correctly...



# Interpret results -----

  # Find means
heartAttaxMeans = heartAttax %>% group_by(sex) %>% 
  summarise(trestbpsMeans = mean(trestbps)) %>% arrange(desc(trestbpsMeans))

View(heartAttaxMeans)
# Note: (If assumptions had been validated, not violated) This determined 
  # that the gender coded as '0' (presumably 'male') had significantly higher
  # resting blood pressure than the gender coded as '1' (presumably 'female')



# Summary -----
# Most assumptions were violated, which means none of the results are valid,
  # if that were not the case, the test determined that gender 0 (presumably
  # 'male') has significantly higher resting blood pressure than gender 1 
  # (presumably 'female'), though gender has no significant impact on 
  # cholesterol