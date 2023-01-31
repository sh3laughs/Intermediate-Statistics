# DSO105 - Intermediate Statistics
  # Lesson 6 - Mixed Measures ANOVAs
  # Page 7 - Mixed Measures ANOVAS Practice Hands-On

# Requirements: This hands on uses this data.
  # You will determine whether suicide rates (suicides/100k pop) has 
    # changed over the years (year), and see if the generation has any 
    # influence. To do so, you will be using a mixed measures ANOVA, since 
    # there is both a repeated time element and a between subjects element. 
    # Provide a one-sentence conclusion at the bottom of your program file 
    # about the analysis you performed.
  # IV 1 (x axis, categorical): generation
  # IV 2 (x axis, categorical / time): year
  # DV (y axis, continuous): suicide rates
  # H0: Suicide rates have not changed over time and generation has no effect
    # H1: Suicide rates have changed over time and generation has an effect


# Setup -----

# Import packages
library(car)
library(dplyr)
library(IDPmisc)
library(rcompanion)


# Import data
soSad = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 6. Mixed Measures ANOVAs/suicide.csv')

View(soSad)
# 27,820 entries, 12 total columns
  # Note: Sample size (40, per 2 IV's) validated (for now...) ... and so 
    # tragic to have so many suicides to merit this quantity of data :( 
  # IV 1 (x axis, categorical): generation
  # IV 2 (x axis, categorical / time): year
  # DV (y axis, continuous): suicides.100k.pop



# Exploration -----

  # Check for missing values
sum(is.na(soSad))
# 19456
  # To do: remove missing values during wrangling


  # Confirm data types
str(soSad)
# generation: string
  # year: numeric
  # suicides.100k.pop: numeric
  # To do: update year to string



# Wrangling -----

  # Remove missing values
soSad1 = NaRV.omit(soSad)

View(soSad1)
# 8,364 entries, 12 total columns
  # Note: Big difference!
  # Also, this still validates the sample size assumption (40, per 2 IV's)


  # Update data type for year
soSad1$yearString = as.character(soSad1$year)

str(soSad1)
# Success!
  # Note: I had to create a new column for this function to work


  # Because there is still a lot of data, I'll subset to only include 
    # defined columns (including country as subject), so queries can run more 
    # quickly
soSadKeep = c('country', 'suicides.100k.pop', 'generation', 'yearString')
soSad2 <- soSad1[soSadKeep]

View(soSad2)
# 8,364 entries, 4 total columns



# Test assumptions -----

  # Check for normal distribution
plotNormalHistogram(soSad2$suicides.100k.pop)
# Positively skewed

    # Transform
soSad2$sadnessSqrt = sqrt(soSad2$suicides.100k.pop)

View(soSad2)
# 8,364 entries, 5 total columns

    # Check distribution again
plotNormalHistogram(soSad2$sadnessSqrt)
# Better.. 

    # Transform again (trying in the other direction, just in case)
soSad2$sadnessLog = log(soSad2$suicides.100k.pop)

View(soSad2)
# 8,364 entries, 6 total columns

    # Check distribution again
plotNormalHistogram(soSad2$sadnessLog)
# Cannot plot, per missing values
  
    # Drop missing values again
soSad3 = NaRV.omit(soSad2)

View(soSad3)
# 7,207 entries, 6 total columns
  # Note: This still validates the sample size assumption (40, per 2 IV's)

    # Check distribution again
plotNormalHistogram(soSad3$sadnessLog)
# Much better - use this


  # Check for homogeneity of variance
leveneTest(sadnessLog ~ generation * yearString, data = soSad3)
# Levene's Test for Homogeneity of Variance (center = median)
#         Df F value    Pr(>F)    
# group   45  6.4015 < 2.2e-16 ***
#       7161                      
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This p value below 0.05 violates the assumption - but I'll keep
    # going anyway, since we haven't yet learned how to correct for this


  # Confirm sample size (40, per 2 IV's)
    # Validated above



# Run analysis -----
soSadMMAnova = aov(suicides.100k.pop ~ (generation * yearString) + 
                      Error(country / yearString), soSad3)

summary(soSadMMAnova)
# Error: country
#                       Df Sum Sq Mean Sq F value Pr(>F)
# generation             5  50231   10046   1.813  0.130
# yearString             9  37272    4141   0.748  0.664
# generation:yearString 31 173514    5597   1.010  0.481
# Residuals             43 238208    5540               
# 
# Error: country:yearString
#                        Df Sum Sq Mean Sq F value   Pr(>F)    
# generation              5  17556    3511  31.031  < 2e-16 ***
# yearString              9   6037     671   5.928 6.29e-08 ***
# generation:yearString  31   3711     120   1.058    0.384    
# Residuals             550  62235     113                     
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Error: Within
#                         Df  Sum Sq Mean Sq F value   Pr(>F)    
# generation               5  335143   67029 314.880  < 2e-16 ***
# generation:yearString   31   22976     741   3.482 2.45e-10 ***
# Residuals             6487 1380889     213                     
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: We didn't see results like this (so long) in lesson, but it looks
    # like generation has a significant impact on suicide, as well as there
    # being a significant change over time for the generational effect - 
    # though there is no significant difference over time apart from the 
    # generational impact - and we do not whether these impacts are high or
    # low; reject the null and accept the alternative hypothesis
      # generation - p < 2e-16: generational impact on suicide
      # generation:yearString - p 2.45e-10: generational impact on suicide 
        # over time



# Post hoc analysis -----

  # Note: The lesson did not teach this, but it was in the provided solution,
    # so I have included here after all since it is useful information...
    # though I realized it was missing one IV in the lesson, so I added here

pairwise.t.test(soSad3$sadnessLog, soSad3$generation, 
                p.adjust = 'bonferroni')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  soSad3$sadnessLog and soSad3$generation 
# Boomers G.I. Generation Generation X Generation Z Millenials
# G.I. Generation 6.5e-16 -               -            -            -         
#   Generation X    1.2e-13 < 2e-16       -            -            -         
#   Generation Z    < 2e-16 < 2e-16       < 2e-16      -            -         
#   Millenials      < 2e-16 < 2e-16       < 2e-16      < 2e-16      -         
#   Silent          1.2e-05 2.0e-05       < 2e-16      < 2e-16      < 2e-16 
# P value adjustment method: bonferroni 
  # Note: The test confirmed that every generation had a significant impact
    # on suicides :( but not yet which were low vs. high


pairwise.t.test(soSad3$sadnessLog, soSad3$yearString, 
                p.adjust = 'bonferroni')
# 		Pairwise comparisons using t tests with pooled SD 
# data:  soSad3$sadnessLog and soSad3$yearString 
#        1985   1990   1995   2000   2005   2010   2011   2012   2013  
#   1990 1.0000 -      -      -      -      -      -      -      -     
#   1995 0.1748 1.0000 -      -      -      -      -      -      -     
#   2000 1.0000 1.0000 1.0000 -      -      -      -      -      -     
#   2005 1.0000 1.0000 1.0000 1.0000 -      -      -      -      -     
#   2010 1.0000 0.8003 0.0067 1.0000 1.0000 -      -      -      -     
#   2011 1.0000 0.5612 0.0040 0.7666 1.0000 1.0000 -      -      -     
#   2012 1.0000 1.0000 0.0232 1.0000 1.0000 1.0000 1.0000 -      -     
#   2013 1.0000 1.0000 0.0266 1.0000 1.0000 1.0000 1.0000 1.0000 -     
#   2014 1.0000 0.8259 0.0078 1.0000 1.0000 1.0000 1.0000 1.0000 1.0000
# P value adjustment method: bonferroni 
  # Note: The test validated that no year had a significant impact on 
    # suicides on its own (only when generational interaction effect is
    # taken into account)



# Interpret results -----

  # Find means
soSadMeans = soSad3 %>% group_by(generation, yearString) %>% 
  summarise(generationMean = mean(suicides.100k.pop))

View(soSadMeans)
# Unfortunately, this shows that for all generations other than Gen Z, the 
  # overall suicide rates have gone up significantly over time; Gen Z has the 
  # lowest rate overall (so low it makes the data questionable), and has gone 
  # done significantly over time