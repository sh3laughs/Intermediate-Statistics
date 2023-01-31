# %%
# DSO105 - Intermediate Statistics
    # Lesson 2 - When Data Isn't Normal

# Page 8 - Transformations in Python Activity

# Requirements: Using the cruise ship data from last lesson, 
    # determine whether each continuous variable is positively skewed, 
    # negatively skewed, or normally distributed. Then perform the 
    # correct transformations to get as close to the normal 
    # distribution as possible for each variable.

# %%
# Import packages
import pandas as pd
import numpy as np
import seaborn as sns
from scipy import stats
from scipy.stats import boxcox
from scipy.stats import norm

# %%
# Import data
cruise = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/cruise_ship.csv')

cruise.head()


# %%
# Check distribution of YearBlt
sns.displot(cruise.YearBlt)

# %%
# Negatively skewed

# Transform
cruise['yearBltSqrd'] = cruise.YearBlt ** 2

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.yearBltSqrd)

# %%
# Not much better

# Transform again
cruise['yearBltCbd'] = cruise.YearBlt ** 3

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.yearBltCbd)

# %%
# A little better, will use this


# %%
# # Check distribution of Tonnage
sns.displot(cruise.Tonnage)

# %%
# Positively skewed

# Transform data
cruise['tonnageSqrt'] = np.sqrt(cruise.Tonnage)

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.tonnageSqrt)

# %%
# Much better! Use this


# %%
# # Check distribution of passngrs
sns.displot(cruise.passngrs)

# %%
# Positively skewed

# Transform data
cruise['passngrsSqrt'] = np.sqrt(cruise.passngrs)

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.passngrsSqrt)

# %%
# Better! Use this


# %%
# # Check distribution of Length
sns.displot(cruise.Length)

# %%
# Slightly negatively skewed

# Transform
cruise['LengthSqrd'] = cruise.Length ** 2

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.LengthSqrd)

# %%
# Not great... but use this (after checking cubed)

# Transform again
cruise['LengthCbd'] = cruise.Length ** 3

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.LengthCbd)

# %%
# Nope, don't use this


# %%
# # Check distribution of Cabins
sns.displot(cruise.Cabins)

# %%
# Slightly positively skewed

# Transform data
cruise['CabinsSqrt'] = np.sqrt(cruise.Cabins)

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.CabinsSqrt)

# %%
# Better! Use this


# %%
# # Check distribution of Crew
sns.displot(cruise.Crew)

# %%
# Slightly positively skewed

# Transform data
cruise['CrewSqrt'] = np.sqrt(cruise.Crew)

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.CrewSqrt)

# %%
# Better! Use this


# %%
# # Check distribution of PassSpcR
sns.displot(cruise.PassSpcR)

# %%
# Slightly positively skewed

# Transform data
cruise['PassSpcRSqrt'] = np.sqrt(cruise.PassSpcR)

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.PassSpcRSqrt)

# %%
# Better! Use this


# %%
# # Check distribution of outcab
sns.displot(cruise.outcab)

# %%
# Slightly positively skewed

# Transform data
cruise['outcabSqrt'] = np.sqrt(cruise.outcab)

cruise.head()

# %%
# Check distribution again
sns.displot(cruise.outcabSqrt)

# %%
# Better! Use this