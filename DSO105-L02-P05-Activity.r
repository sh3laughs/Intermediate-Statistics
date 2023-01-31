# DSO105 - Intermediate Statistics
  # Lesson 2 - When Data Isn't Normal
  # Page 5 - Transformations in R Activity

# Import packages 
library(rcompanion)
library(IDPmisc)

# Import data
cruise = read.csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/cruise_ship.csv')

View(cruise)


# Requirements: Using the cruise ship data from last lesson, determine 
  # whether each continuous variable is positively skewed, negatively 
  # skewed, or normally distributed. Then perform the correct 
  # transformations to get as close to the normal distribution as possible 
  # for each variable.

# Check distribution of YearBlt
plotNormalHistogram(cruise$YearBlt)
# Negatively skewed

# Transform
cruise$YearBltSquared = cruise$YearBlt ^ 2

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$YearBltSquared)
# A little better

# Transform again
cruise$YearBltCubed = cruise$YearBlt ^ 3

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$YearBltCubed)
# Best, I think - use this


# Check distribution of Tonnage
plotNormalHistogram(cruise$Tonnage)
# Positively skewed

# Transform
cruise$TonnageSqrt = sqrt(cruise$Tonnage)

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$TonnageSqrt)
# Better - use this


# Check distribution of passngrs
plotNormalHistogram(cruise$passngrs)
# Slightly positively skewed

# Transform
cruise$passngrsSqrt = sqrt(cruise$passngrs)

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$passngrsSqrt)
# Better - use this


# Check distribution of Length
plotNormalHistogram(cruise$Length)
# Slightly negatively skewed

# Transform
cruise$LengthSquared = cruise$Length ^ 2

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$LengthSquared)
# Better - use this (confirmed after trying cubed, too, below)

# Transform again
cruise$LengthCubed = cruise$Length ^ 3

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$LengthCubed)
# Worse


# Check distribution of Cabins
plotNormalHistogram(cruise$Cabins)
# Positively skewed

# Transform
cruise$CabinsSqrt = sqrt(cruise$Cabins)

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$CabinsSqrt)
# Better - use this


# Check distribution of Crew
plotNormalHistogram(cruise$Crew)
# Slightly positively skewed

# Transform
cruise$CrewSqrt = sqrt(cruise$Crew)

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$CrewSqrt)
# Better - use this


# Check distribution of PassSpcR
plotNormalHistogram(cruise$PassSpcR)
# Normally distributed.. well.. according to the line.. the bars make
  # it look slightly positively skewed

# Transform
cruise$PassSpcRSqrt = sqrt(cruise$PassSpcR)

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$PassSpcRSqrt)
# Just better enough to use ;)


# Check distribution of outcab
plotNormalHistogram(cruise$outcab)
# Slightly positively skewed

# Transform
cruise$outcabSqrt = sqrt(cruise$outcab)

View(cruise)

# Check distribution again
plotNormalHistogram(cruise$outcabSqrt)
# Better - use this