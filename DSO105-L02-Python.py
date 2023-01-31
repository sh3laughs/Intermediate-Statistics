# %%
# DSO105 - Intermediate Statistics
    # Lesson 2 - When Data Isn't Normal

# Page 7 - Transformations in Python

    # From video

# Import packages
import pandas as pd
import numpy as np
import seaborn as sns
from scipy import stats
from scipy.stats import boxcox

# %%
# Import data
golf = pd.read_excel('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/pgaTourData.xlsx')

golf.head()


# %%
# Check distribution of Top 10
golf['Top 10'].hist()

# %%
# Positively skewed

# Use alternate graph option
sns.distplot(golf['Top 10'])

# %%
# Positively skewed

# Drop missing values
golf2 = golf.copy()

golf2.dropna(inplace = True)

golf2.head()

# %%
# Rerun new graph
sns.distplot(golf2['Top 10'])

# %%
# Histogram - and with a line! :) - revalidates the positive skew,
    # though far less than before dropping missing values

# Transform data
golf2['top10sqrt'] = np.sqrt(golf2['Top 10'])

golf2.head()

# %%
# Recheck distribution
sns.distplot(golf2.top10sqrt)

# %%
# Slightly more normal distribution - use this (confirmed after 
    # trying log)

# Transform again to be super sure
golf2['top10log'] = np.log(golf2['Top 10'])

golf2.head()

# %%
# Check distribution again
sns.distplot(golf2.top10log)

# %%
# Worse ;)


# %%
# Check distribution of SG:ARG
sns.distplot(golf2['SG:ARG'])

# %%
# Slightly negatively skewed - use this (confirmed after trying squared 
    # and cubed)

# Transform
golf2['sgArgSquared'] = golf2['SG:ARG'] ** 2

golf2.head()

# %%
# Check distribution again
sns.distplot(golf2.sgArgSquared)

# %%
# So much worse, haha

# Transform again
golf2['sgArgCubed'] = golf2['SG:ARG'] ** 3

golf2.head()

# %%
# Check distribution again
sns.distplot(golf2.sgArgCubed)

# %%
# Also terrible ;)



# %%
    # From lesson

# Import data
anime = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/anime.csv')

anime.head()


# %%
# Check distribution for aired_from_year
anime.aired_from_year.hist()

# %%
# Very negatively skewed

# Check distribution again with best fit line
sns.distplot(anime.aired_from_year)

# %%
# More visually clear.. aaand still negatively skewed

# Transform
anime['airedFromYearSquared'] = anime.aired_from_year ** 2

anime.head()

# %%
# Check distribution again
sns.distplot(anime.airedFromYearSquared)

# %%
# Barely better

# Transform again
anime['airedFromYearCubed'] = anime.aired_from_year ** 3

anime.head()

# %%
# Check distribution again
sns.distplot(anime.airedFromYearCubed)

# %%
# Barely bettter again.. and lesson is moving us on..


# %%
# Check distribution for scored_by
sns.displot(anime.scored_by)

# %%
# Extremely positively skewed

# Transform
anime['scoredBySqrt'] = np.sqrt(anime.scored_by)

anime.head()

# %%
# Check distribution again
sns.distplot(anime.scoredBySqrt)

# %%
# Better but still very skewed

# Tranform again
anime['scoredByLog'] = np.log(anime.scored_by)

anime.head()

# %%
# Check distribution again
sns.distplot(anime.scoredByLog)

# %%
# Error due to infinite values

# Drop missing values
anime2 = anime.copy()

anime2.dropna(inplace=True)

anime2.head()

# %%
# Check distribution again
sns.distplot(anime2.scoredByLog)

# %%
# Much more normally distributed! Can use this.. also it mentioned this 
    # function being deprecated, and should use displot or histplot - 
    # so testing those
sns.displot(anime2.scoredByLog)

# %%
# Doesn't include a best fit line (tried histplot with identical 
    # results...), so I'll stick with distplot for now

# Re-do last transformation with an alternate function
anime2['scoredByLog2'] = boxcox(anime2.scored_by, 0)

anime2.head()

# %%
# Data looks identical, so that's good

# Check distribution again (using other function, just for fun)
sns.distplot(anime2.scoredByLog)

# %%
# Also identical ;)