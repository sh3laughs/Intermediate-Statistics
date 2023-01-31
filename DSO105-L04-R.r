# DSO105 - Intermediate Statistics
  # Lesson 4 - Basic ANOVAs

# Page 1 - Introduction -----
  # From video workshop: https://vimeo.com/444752189

# Import packages
library(dplyr)
library(rcompanion)
library(car)
library(ggplot2)
library(IDPmisc)

# Import and preview data
border = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/BorderCrossing.csv')

View(border)
# 355,511 entries, 7 total columns


# Goal for test: Determine if the # of people who cross borders differs by how 
  # they cross
    # H0: The # of people who cross borders is approx. the same no matter 
        # how they cross
      # H1: The # of people who cross borders differs by how they cross

# Test assumptions

  # Check distribution
plotNormalHistogram(border$Value)
# Very positively skewed

  # Transform
border$ValueSqrt = sqrt(border$Value)

View(border)
# 355,511 entries, 8 total columns

  # Check distribution again
plotNormalHistogram(border$ValueSqrt)
# Better...

  # Transform again
border$ValueLog = log(border$Value)

View(border)
# 355,511 entries, 9 total columns

  # Check distribution again
plotNormalHistogram(border$ValueLog)
# Can't plot, per infinite values

  # Drop NA's
border2 = NaRV.omit(border)

View(border2)
# 233,119 entries, 9 total columns

  # Check distribution again
plotNormalHistogram(border2$ValueLog)
# Hurray! Almost perfectly normally distributed


  # Check for homogeneity of variance
bartlett.test(ValueLog ~ Measure, data = border2)
#         Bartlett test of homogeneity of variances
# data:  ValueLog by Measure
# Bartlett's K-squared = 21600, df = 11, p-value < 2.2e-16

  # Note: The p value under 0.05 is test is significant, which violates the 
    # assumption of homogeneity of variance (this is heterogeneity of 
    # variance)


# Create model
borderAnova = lm(ValueLog ~ Measure, data = border2)

Anova(borderAnova, Type = 'II', white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# 
# Response: ValueLog
# Df     F    Pr(>F)    
# Measure       11 18105 < 2.2e-16 ***
#   Residuals 233107                    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

  # Note: The p value under 0.05 validates significance - validating that the
    # number of people who cross borders differs by how they cross, though
    # it doesn't tell us how it differs; reject the null and accept the 
    # alternative hypothesis


# Post hoc analysis

  # Run pairwise t test
pairwise.t.test(border$Value, border$Measure, p.adjust = 'bonferroni', 
                pool.sd = FALSE)
# 	Pairwise comparisons using t tests with non-pooled SD 
# data:  border$Value and border$Measure 
# 
# Bus Passengers Buses   Pedestrians
# Buses                       < 2e-16        -       -          
#   Pedestrians                 < 2e-16        < 2e-16 -          
#   Personal Vehicle Passengers < 2e-16        < 2e-16 < 2e-16    
# Personal Vehicles           < 2e-16        < 2e-16 < 2e-16    
# Rail Containers Empty       < 2e-16        < 2e-16 < 2e-16    
# Rail Containers Full        < 2e-16        < 2e-16 < 2e-16    
# Train Passengers            < 2e-16        7.4e-11 < 2e-16    
# Trains                      < 2e-16        < 2e-16 < 2e-16    
# Truck Containers Empty      < 2e-16        < 2e-16 < 2e-16    
# Truck Containers Full       1.3e-13        < 2e-16 < 2e-16    
# Trucks                      < 2e-16        < 2e-16 < 2e-16    
# Personal Vehicle Passengers Personal Vehicles
# Buses                       -                           -                
#   Pedestrians                 -                           -                
#   Personal Vehicle Passengers -                           -                
#   Personal Vehicles           < 2e-16                     -                
#   Rail Containers Empty       < 2e-16                     < 2e-16          
# Rail Containers Full        < 2e-16                     < 2e-16          
# Train Passengers            < 2e-16                     < 2e-16          
# Trains                      < 2e-16                     < 2e-16          
# Truck Containers Empty      < 2e-16                     < 2e-16          
# Truck Containers Full       < 2e-16                     < 2e-16          
# Trucks                      < 2e-16                     < 2e-16          
# Rail Containers Empty Rail Containers Full
# Buses                       -                     -                   
#   Pedestrians                 -                     -                   
#   Personal Vehicle Passengers -                     -                   
#   Personal Vehicles           -                     -                   
#   Rail Containers Empty       -                     -                   
#   Rail Containers Full        < 2e-16               -                   
#   Train Passengers            < 2e-16               < 2e-16             
# Trains                      < 2e-16               < 2e-16             
# Truck Containers Empty      < 2e-16               < 2e-16             
# Truck Containers Full       < 2e-16               < 2e-16             
# Trucks                      < 2e-16               < 2e-16             
# Train Passengers Trains  Truck Containers Empty
# Buses                       -                -       -                     
#   Pedestrians                 -                -       -                     
#   Personal Vehicle Passengers -                -       -                     
#   Personal Vehicles           -                -       -                     
#   Rail Containers Empty       -                -       -                     
#   Rail Containers Full        -                -       -                     
#   Train Passengers            -                -       -                     
#   Trains                      < 2e-16          -       -                     
#   Truck Containers Empty      < 2e-16          < 2e-16 -                     
#   Truck Containers Full       < 2e-16          < 2e-16 < 2e-16               
# Trucks                      < 2e-16          < 2e-16 < 2e-16               
# Truck Containers Full
# Buses                       -                    
#   Pedestrians                 -                    
#   Personal Vehicle Passengers -                    
#   Personal Vehicles           -                    
#   Rail Containers Empty       -                    
     
#   Train Passengers            -                    
#   Trains                      -                    
#   Truck Containers Empty      -                    
#   Truck Containers Full       -                    
#   Trucks                      < 2e-16              
# 
# P value adjustment method: bonferroni

  # Note: Lots of levels for the Measure variable have significance, but
    # this (again) doesn't explain the significance (ie: higher / lower)

  # Look at means
borderMeans = border %>% group_by(Measure) %>% summarise(
  Mean = mean(Value)) %>% arrange(desc(Mean))

View(borderMeans)
# Data should be wrangled more to more useful, but... this does validate
  # that borders are most often crossed by people in passenger vehicles



# Page 4 - One Way ANOVAS in R Setup -----

  # From video

# Goal: Determine whether prices change based on staff member
  # H0: The prices is approx. the same for all staff members
    # H1: The price is different for different staff members


# Import and preview data
salonCxl = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/client_cancellations.csv')

View(salonCxl)
# 243 entries, 11 total columns


# Test assumptions

  # Check for normal distribution
plotNormalHistogram(salonCxl$avg.price)
# Positively skewed

    # Transform
salonCxl$avgPrcSqrt = sqrt(salonCxl$avg.price)

View(salonCxl)
# 243 entries, 12 total columns


    # Check distribution again
plotNormalHistogram(salonCxl$avgPrcSqrt)
# Great - use this


  # Check for homogeneity of variance (normal distribution)
bartlett.test(avgPrcSqrt ~ staff, data = salonCxl)
# 	Bartlett test of homogeneity of variances
# data:  avgPrcSqrt by staff
# Bartlett's K-squared = 55.268, df = 5, p-value = 1.15e-10
  # Note: This found significance, which violated this assumption

    # Check for homogeneity of variance (non-parametric data)
fligner.test(avg.price ~ staff, data = salonCxl)
# 	Fligner-Killeen test of homogeneity of variances
# data:  avg.price by staff
# Fligner-Killeen:med chi-squared = 60.382, df = 5, p-value = 1.013e-11
  # Note: This also found significance, which violated this assumption
  # Doing both tests is not normal, just for practice to learn both


  # Confirm sample size
View(salonCxl)
# 243 entries, 12 total columns
  # Note: This validates the assumption


  # No way to test for indpeendence



  # From lesson

# Goal of test: Is there a difference in price among the three app 
    # categories of beauty, food and drink, and photography? 
  # IV (x axis): Category
  # DV (y axis): Price
  # H0: The price for all three categories is approx. the same
    # H1: The price is different for different categories

# Import data
android = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 4. Basic ANOVAs/googleplaystore.csv')

View(android)
# 10,841 entries, 14 total columns


# Wrangling

  # Filter data to remove NA's and include only 3 categories
apps = na.omit(android %>% filter(
  Category %in% c('BEAUTY', 'FOOD_AND_DRINK', 'PHOTOGRAPHY')))

View(apps)
# 468 entries, 14 total columns

  # Update data type for Price to be numeric
apps$Price = as.numeric(apps$Price)

str(apps)
# success


# Test assumptions

# Check distribution
plotNormalHistogram(apps$Price)
# Positively skewed

  # Transform
apps$PriceSqrt = sqrt(apps$Price)

  # Check distribution again
plotNormalHistogram(apps$PriceSqrt)
# A little better

  # Transform again
    # NOTE: I diverge from what was in lesson at this point, b/c the -----
      # lesson content was wrong (it used cube instead of logarithm)
      # b/c of this divergence, my results are different... but for the 
      # sake of practice I proceeded (through next page, as well, which
      # picked up where this page left off) to run things on my 
      # transformed data, which met assumptions and the original data, 
      # which did not
apps$PriceLog = log(apps$Price)

  # Check distribution again
plotNormalHistogram(apps$PriceLog)
# Error re: infinite values

  # Drop NA's
apps2 = NaRV.omit(apps)

View(apps2)
# 20 entries, 16 total columns

  # Check distribution again
plotNormalHistogram(apps2$PriceLog)
# Much better - use this


# Check for homogeneity of variance on transformed data (normal
  # distribution)
bartlett.test(PriceLog ~ Category, data = apps2)
#         Bartlett test of homogeneity of variances
# data:  PriceLog by Category
# Bartlett's K-squared = 0.77244, df = 1, p-value = 0.3795

# Note: This p value over 0.05 means we do not have significance, which
  # means this assumption can be validated - in the transformed data we 
  # have homogeneity of variance

  # Check for homogeneity of variance on original data (non-parametric)
fligner.test(Price ~ Category, data = apps)
# 	Fligner-Killeen test of homogeneity of variances
# data:  Price by Category
# Fligner-Killeen:med chi-squared = 4.878, df = 2, p-value = 0.08725

# Note: This p value under 0.05 means we do have significance, which means
  # this assumption has been violated - the original data is heterogeneic


  # Check sample size
View(apps)
# 468 entries, 16 total columns
  # Note: The original dataset meets this assumption (20+ rows)

View(apps2)
# 20 entries, 16 total columns
  # Note: The transformed dataset meets this assumption (20+ rows)



# Page 5 - One Way ANOVAS in R -----

  # From video

# Run analysis

  # Validated assumption of homogeneity of variance
    # Note: This assumption was actually validated, but we are doing for 
    # practice to learn both test options
salonCxlAnova = aov(salonCxl$avgPrcSqrt ~ salonCxl$staff)

summary(salonCxlAnova)
#                 Df Sum Sq Mean Sq F value   Pr(>F)    
# salonCxl$staff   5  223.8   44.77    8.11 4.45e-07 ***
# Residuals      235 1297.2    5.52                     
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 2 observations deleted due to missingness
  # Note: This determined that there is a significant impact on price based
    # on staff member (though we don't know which staff are high/ low yet);
    # reject the null and accept the alternative hypothesis


  # Violated assumption of homogeneity of variance
salonCxlAnova2 = lm(avgPrcSqrt ~ staff, data = salonCxl)

Anova(salonCxlAnova2, Type = 'II', white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# Response: avgPrcSqrt
#            Df      F    Pr(>F)    
# staff       5 5.6727 5.841e-05 ***
# Residuals 235                     
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
  # Note: This also determined that there is a significant impact on price 
    # based on staff member (though we don't know which staff are high/ low 
    # yet)



# Post hoc analysis
pairwise.t.test(salonCxl$avgPrcSqrt, salonCxl$staff, p.adjust = 'bonferroni')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  salonCxl$avgPrcSqrt and salonCxl$staff 
#        BECKY   JJ     JOANNE KELLY  SINEAD
# JJ     0.1555  -      -      -      -     
# JOANNE 7.2e-08 0.0023 -      -      -     
# KELLY  0.6995  1.0000 0.0031 -      -     
# SINEAD 1.0000  1.0000 0.0017 1.0000 -     
# TANYA  1.0000  1.0000 0.2397 1.0000 1.0000
# P value adjustment method: bonferroni
  # Note: This indicates that there is a significant difference in price
    # between: 
      # Joanne and Becky
      # Joanne and JJ
      # Sinead and Joanne
      # Tanya and Joanne
    # This indicates Joanne's prices are significantly different from everyone
      # else's - though we still don't know high/ low



# Interpret results
  
  # Find means (using pre-transformed data)
salonCxlMeans = salonCxl %>% group_by(staff) %>% 
  summarise(avgPrcMean = mean(avg.price))

View(salonCxlMeans)
# Need to remove NAs


    # Remove missing values
salonCxl2 = NaRV.omit(salonCxl)

View(salonCxl2)
# 241 entries, 12 total columns


    # Re-check means
salonCxlMeans2 = salonCxl2 %>% group_by(staff) %>% 
  summarise(avgPrcMean = mean(avg.price))

View(salonCxlMeans2)
# Note: This shows that Joanne's prices are significantly more expensive 
  # than all other staff members'



  # From lesson

# Computing ANOVAs with Equal Variance (Met Homogeneity of Variance 
    # Assumption)
  # NOTE: Per note above (line 219) my results differed from lesson on 
    # prior page, per a mistake in lesson content, so I am running code
    # on this page on different data than the lesson content did - in this
    # case my transformed data met this (and all) assumption(s), so I am 
    # using that data
apps2Anova = aov(apps2$Price ~ apps2$Category)

summary(apps2Anova)
#                Df Sum Sq Mean Sq F value Pr(>F)
# apps2$Category  1    0.8   0.789   0.045  0.835
# Residuals      18  316.9  17.606

# Note: This p value (0.835) determines this test is not significant - 
  # there is no significant difference in price among the three app 
  # categories of beauty, food and drink, and photography; accept the null and 
  # reject the alternative hypothesis


# Computing ANOVAs with Unequal Variance (Violated Homogeneity of Variance 
    # Assumption)
  # NOTE: I am running this on the same data as the lesson - the original
    # (non-transformed) dataset, because it violated this assumption

# Run a Welch's One Way test
appsAnova = lm(Price ~ Category, data = apps)

Anova(appsAnova, Type = 'II', white.adjust = TRUE)
# Analysis of Deviance Table (Type II tests)
# Response: Price
# Df      F  Pr(>F)   
# Category    2 6.3142 0.00197 **
#   Residuals 465                  
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

  # Note: The p value (0.00197) determined that this test is significant - 
    # there is a significant difference in price among the three app 
    # categories of beauty, food and drink, and photography (though we
    # don't know which is higher / lower); reject the null and accept the 
    # alternative hypothesis


# Post hocs

  # Computing Post Hocs with No Adjustment - original dataset
pairwise.t.test(apps$Price, apps$Category, p.adjust = 'none')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  apps$Price and apps$Category 
#                BEAUTY FOOD_AND_DRINK
# FOOD_AND_DRINK 0.74   -             
# PHOTOGRAPHY    0.19   0.16          
# P value adjustment method: none
  # Note: No significance in any pairs - contradicts p value in test above;
    # accept the null and reject the alternative hypothesis


# Computing Post Hocs with No Adjustment - transformed dataset
pairwise.t.test(apps2$Price, apps2$Category, p.adjust = 'none')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  apps2$Price and apps2$Category 
#             FOOD_AND_DRINK
# PHOTOGRAPHY 0.83          
# P value adjustment method: none 
  # Note: No significance in the only pair; accept the null and reject the 
    # alternative hypothesis - validates p value in test above
    # This also shows that the transformation removed the Beauty category
    # completely...


# Computing Post Hocs with Bonferroni Adjustment - original dataset
pairwise.t.test(apps$Price, apps$Category, p.adjust = 'bonferroni')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  apps$Price and apps$Category 
#                BEAUTY FOOD_AND_DRINK
# FOOD_AND_DRINK 1.00   -             
# PHOTOGRAPHY    0.56   0.48        
# P value adjustment method: bonferroni 
  # Note: No significance in any pairs - contradicts p value in test above,
    # even less than the post hoc test without adjustment


# Computing Post Hocs with Bonferroni Adjustment - transformed dataset
pairwise.t.test(apps2$Price, apps2$Category, p.adjust = 'bonferroni')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  apps2$Price and apps2$Category 
#             FOOD_AND_DRINK
# PHOTOGRAPHY 0.83          
# P value adjustment method: bonferroni 
  # Note: No significance in the only pair - validates p value in test above
    # This is also the same value as the unadjusted post hoc test above...


# Computing Post Hocs When You've Violated the Assumption of Homogeneity 
  # of Variance - original dataset (won't do transformed, since it did
  # not validate this assumption)
pairwise.t.test(apps$Price, apps$Category, p.adjust = 'bonferroni',
                pool.sd = FALSE)
# 	Pairwise comparisons using t tests with non-pooled SD 
# data:  apps$Price and apps$Category 
#                BEAUTY FOOD_AND_DRINK
# FOOD_AND_DRINK 0.4943 -             
# PHOTOGRAPHY    0.0035 0.1470        
# P value adjustment method: bonferroni
  # Note: This indicates that there is significance in the difference in 
    # price between Beauty and Photography app categories... which cannot
    # be validated in the transformed data since Beauty disappeared...


  # Find means
appsMeans = apps %>% group_by(Category) %>% summarise(Mean = mean(Price))

View(appsMeans)
# Validates that the average cost is very low for all three of these 
  # categories... and if there really is significance in the pair above, 
  # then it is significantly cheaper