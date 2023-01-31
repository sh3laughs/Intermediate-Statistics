# DSO105 - Intermediate Statistics
  # Lesson 2 - When Data Isn't Normal

# Page 4 - Transformations in R

  # From video

# Install and import packages 
install.packages(rcompanion)

library(rcompanion)
library(IDPmisc)
library(readxl)


# Import data
golf = read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/pgaTourData.xlsx')

View(golf)


# Check distribution of wins variable
plotNormalHistogram(golf$Wins)
# The data are very positively skewed

# Transform
golf$WinsSqrt = sqrt(golf$Wins)

View(golf)

# Check distribution of wins square root variable
plotNormalHistogram(golf$WinsSqrt)
# Only a slight improvement

# Try another transformation
golf$WinsLog = log(golf$Wins)

View(golf)

# Check distribution of wins logarithm
plotNormalHistogram(golf$WinsLog)
# No better

# Remove missing data
golf2 = NaRV.omit(golf)

View(golf2)

# Check distribution again, for original variable
plotNormalHistogram(golf2$Wins)
# Better...

# Check logarithm in new data
plotNormalHistogram(golf2$WinsLog)
# Not better

# Check square root in new data
plotNormalHistogram(golf2$WinsSqrt)
# Also not better - will (would?) use original, with missing values removed


# Check distribution of average SG total
plotNormalHistogram(golf2$'Average SG Total')
# Slightly negatively skewed

# Transform data
golf2$AverageSGTotalSquared = golf2$'Average SG Total' ^ 2

View(golf2)

# Check distribution again
plotNormalHistogram(golf2$AverageSGTotalSquared)
# Worse, will use original


# Check distribution of SG:ARG
plotNormalHistogram(golf2$'SG:ARG')
# Slightly negatively skewed

# Transform
golf2$sgArgSquared = golf2$'SG:ARG' ^ 2

View(golf2)

# Check distribution again
plotNormalHistogram(golf2$sgArgSquared)
# Worse

# Transform again
golf2$sgArgCubed = golf2$'SG:ARG' ^ 3

View(golf2)

# Check distribution again
plotNormalHistogram(golf2$sgArgCubed)
# Worse - use original


# Check distribution of Top 10
plotNormalHistogram(golf2$'Top 10')
# A bit positively skewed

# Transform
golf2$top10tukey = transformTukey(golf2$'Top 10', plotit = TRUE)
# Output:
  # lambda      W Shapiro.p.value
  # 426  0.625 0.9589       3.521e-07
  # 
  # if (lambda >  0){TRANS = x ^ lambda} 
  # if (lambda == 0){TRANS = log(x)} 
  # if (lambda <  0){TRANS = -1 * x ^ lambda} 
# lambda = 0.625
  # Because this is greater than 0, it used first equation
# Note: This also output a scatterplot, which shows it's muc more 
  # normally distributed now

# Check distribution again via histogram
plotNormalHistogram(golf2$top10tukey)
# More normally distributed - use this



  # From lesson

# Import data
anime = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/anime.csv')

View(anime)


# Check distribution for score
plotNormalHistogram(anime$score)
# Pretty normally distributed!


# Check distribution for scored_by
plotNormalHistogram(anime$scored_by)
# positively skewed

# Transform
anime$scoredBySqrt = sqrt(anime$scored_by)

View(anime)

# Check distribution again
plotNormalHistogram(anime$scoredBySqrt)
# better...

# Transform again
anime$scoredByLog = log(anime$scored_by)

# Check distribution again
plotNormalHistogram(anime$scoredByLog)
# Error: 
  # Error in seq.default(min(x), max(x), length = length) : 
  #   'from' must be a finite number

# Remove missing values
anime2 = NaRV.omit(anime)

View(anime2)
# This has 6,306 rows and original dataset had 6,668

# Check distribution again
plotNormalHistogram(anime2$scoredByLog)
# Success! Normally distributed - use this


# Check distribution for aired_from_year
plotNormalHistogram(anime$aired_from_year)
# Negatively skewed

# Transform
anime$airedFromYearSquared = anime$aired_from_year ^ 2

View(anime)

# Check distribution again
plotNormalHistogram(anime$airedFromYearSquared)
# Barely different

# Transform again
anime$airedFromYearCubed = anime$aired_from_year ^ 3

View(anime)

# Check distribution again
plotNormalHistogram(anime$airedFromYearCubed)
# Best so far - use this


# Import more data
cruise = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/cruise_ship.csv')

View(cruise)

# Check distribution of Tonnage
plotNormalHistogram(cruise$Tonnage)
# Slighly positively skewed

# Transform
cruise$TonnageTuk = transformTukey(cruise$Tonnage)
# Output:
  # lambda      W Shapiro.p.value
  # 431   0.75 0.9852         0.09082
  # 
  # if (lambda >  0){TRANS = x ^ lambda} 
  # if (lambda == 0){TRANS = log(x)} 
  # if (lambda <  0){TRANS = -1 * x ^ lambda}
# lambda = 0.75, which is greater than 0, so the top equation was used
# Note: Because I excluded the plotit argument, it did plot

# Check distribution again
plotNormalHistogram(cruise$TonnageTuk)
# Success! Use this