# # DSO105 - Intermediate Statistics
  # Lesson 2 - When Data Isn't Normal
  # Page 11 - R Hands-On

# Requirements: This hands on uses a dataset about the number of trips 
  # done at the Seattle Parks and Recreation department. It is 
  # located here. For each part, assess and transform the requested 
  # data, then submit your annotated program files for review.

# Part II: Transforming Data in R
  # In R, assess the skew of the distribution and then transform it 
    # if necessary for the following variables:
      # # of trips Fall
        # Conclusion:
          # Positively skewed
          # Use logarithm
      # # of participants Fall
        # Conclusion:
          # Positively skewed
          # Use square root
      # # of trips per Year
        # Conclusion:
          # Positively skewed
          # Use logarithm
      # participants per Year
        # Conclusion:
          # Positively skewed
          # Use logarithm
      # increase/decrease of prior year
        # Conclusion:
          # Positively skewed
          # Use square root (with NA's removed)
      # Average # people per trip
        # Conclusion:
          # Positively skewed
          # Use square root
  # Please make notes about each variable's distribution and the 
    # transformation you made in your R script and submit.

# Import packages
library(rcompanion)
library(IDPmisc)
library(PerformanceAnalytics)

# Import and preview data
seattlePnr = read.csv("/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 2. When Data Isn't Normal/Seattle_ParksnRec.csv")

View(seattlePnr)                      
# 60 rows, 14 columns


# Check distribution of full dataset
  # Drop string data
seattlePnr2 = subset(seattlePnr, select = -c(Geographic.Region))

View(seattlePnr2)
# 60 rows, 13 columns

  # Plot full dataset
chart.Correlation(seattlePnr2, histogram = TRUE)
# Helpful preview... all variables for this Part II appear to be
  # positively skewed (some more than others), as with the Part I
  # variables in Python


# Transform '# of trips Fall' (note: using original dataset since
  # the 2 version was just needed for the matrix)
seattlePnr$tripsFallSqrt = sqrt(seattlePnr$X..of.trips.Fall)
# OMG... this took over an hour and LOTS of code and Googling to
  # get to run due to errors about non-numeric data when trying
  # this and other transformations - which I confirmed via str()
  # was not true, and errors about infinite values when trying to
  # plot - which I confirmed wasn't true when I removed NA's and 
  # there was no difference (because there were no missing values
  # to begin with)... only to finally realize the problem was that 
  # the variable names were updated when I imported, and I hadn't 
  # noticed and was using the original names. Lesson learned!!
  # Also realized after finally figuring this out that R will 
  # auto-fill column names if they exist ;) so that should have 
  # been a clue much sooner, that it wasn't doing that

View(seattlePnr)
# 60 rows, 15 columns

# Check distribution of transformed data
plotNormalHistogram(seattlePnr$tripsFallSqrt)
# Better but still skewed

# Transform again
seattlePnr$tripsFallLog = log(seattlePnr$X..of.trips.Fall)

View(seattlePnr)
# 60 rows, 16 columns

# Check distribution again
plotNormalHistogram(seattlePnr$tripsFallLog)
# Better!! Use this


# Transform '# of participants Fall'
seattlePnr$partsFallSqrt = sqrt(seattlePnr$X..of.participants.Fall)

View(seattlePnr)
# 60 rows, 17 columns

# Check distribution of transformed data
plotNormalHistogram(seattlePnr$partsFallSqrt)
# Looks pretty good.. use this (confirmed after checking logarithm)

# Transform again
seattlePnr$partsFallLog = log(seattlePnr$X..of.participants.Fall)

View(seattlePnr)
# 60 rows, 18 columns

# Check distribution again
plotNormalHistogram(seattlePnr$partsFallLog)
# Debatable, but I think square root was better, would use that


# Transform '# of trips per year'
seattlePnr$tripsYrSqrt = sqrt(seattlePnr$X..of.trips.per.year)

View(seattlePnr)
# 60 rows, 19 columns

# Check distribution of transformed data
plotNormalHistogram(seattlePnr$tripsYrSqrt)
# Looks pretty good.. 

# Transform again
seattlePnr$tripsYrLog = log(seattlePnr$X..of.trips.per.year)

View(seattlePnr)
# 60 rows, 20 columns

# Check distribution again
plotNormalHistogram(seattlePnr$tripsYrLog)
# Better!! Use this


# Transform '# of participants per year'
seattlePnr$partsYrSqrt = sqrt(seattlePnr$X..participants.per.year)

View(seattlePnr)
# 60 rows, 21 columns

# Check distribution of transformed data
plotNormalHistogram(seattlePnr$partsYrSqrt)
# Looks pretty good.. 

# Transform again
seattlePnr$partsYrLog = log(seattlePnr$X..of.trips.per.year)

View(seattlePnr)
# 60 rows, 22 columns

# Check distribution again
plotNormalHistogram(seattlePnr$partsYrLog)
# Better!! Use this


# Transform 'increase/decrease of prior year'
seattlePnr$incDecYrSqrt = 
  sqrt(seattlePnr$increase.decrease.of.prior.year)
# Warning message:
  # In sqrt(seattlePnr$increase.decrease.of.prior.year) : NaNs 
  # produced
# Note: This means I'll need to drop NA's to be able to plot

View(seattlePnr)
# 60 rows, 23 columns

# Drop NA's
seattlePnr3 = NaRV.omit(seattlePnr)

View(seattlePnr3)
# 29 rows, 23 columns

# Check distribution of transformed data (in original dataset)
plotNormalHistogram(seattlePnr3$incDecYrSqrt)
# Looks pretty good.. use this (confirmed after checking logarithm)

# Transform again
seattlePnr$incDecYrLog = 
  log(seattlePnr$increase.decrease.of.prior.year)
# Warning message:
  # In log(seattlePnr$increase.decrease.of.prior.year) : NaNs 
  # produced

# Note: This means I'll need to drop NA's to be able to plot

View(seattlePnr)
# 60 rows, 24 columns

# Drop NA's
seattlePnr4 = NaRV.omit(seattlePnr)

View(seattlePnr4)
# 24 rows, 24 columns

# Check distribution again
plotNormalHistogram(seattlePnr4$incDecYrLog)
# Worse - use square root


# Transform 'Average # people per trip'
seattlePnr$avgPplTripSqrt = 
  sqrt(seattlePnr$Average...people.per.trip)

View(seattlePnr)
# 60 rows, 25 columns

# Check distribution of transformed data
plotNormalHistogram(seattlePnr$avgPplTripSqrt)
# Looks pretty good.. use this (confirmed after checking logarithm)

# Transform again
seattlePnr$avgPplTripLog = 
  log(seattlePnr$Average...people.per.trip)

View(seattlePnr)
# 60 rows, 26 columns

# Check distribution again
plotNormalHistogram(seattlePnr$avgPplTripLog)
# Debatable, but I think square root was better, would use that