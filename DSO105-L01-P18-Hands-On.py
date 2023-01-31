# %%
# DSO105 - Intermediate Statistics
    # Lesson 1 - Basic Statistics in Python

# Page 18 - Anime Hands-On

# Requirements: Using the anime dataset you worked with in the lesson, 
    # perform the appropriate analyses and answer the following 
    # questions (starting line 71) in your Python file.

# %%
# Import packages
import pandas as pd
import numpy as np
from scipy.stats import norm
from scipy import stats
from scipy.stats import ttest_ind
import matplotlib.pyplot as plt
import seaborn as sns

# %%
# Import and preview data
anime = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/anime.csv')

anime.head()

# %%
anime.info()

# %%
# Output:
#   Column           Non-Null Count  Dtype  
# ---  ------           --------------  -----  
#  0   anime_id         6668 non-null   int64  
#  1   title            6668 non-null   object 
#  2   title_english    3438 non-null   object 
#  3   title_japanese   6663 non-null   object 
#  4   title_synonyms   4481 non-null   object 
#  5   image_url        6666 non-null   object 
#  6   type             6668 non-null   object 
#  7   source           6668 non-null   object 
#  8   episodes         6668 non-null   int64  
#  9   status           6668 non-null   object 
#  10  airing           6668 non-null   bool   
#  11  aired_string     6668 non-null   object 
#  12  aired            6668 non-null   object 
#  13  duration         6668 non-null   object 
#  14  rating           6668 non-null   object 
#  15  score            6668 non-null   float64
#  16  scored_by        6668 non-null   int64  
#  17  rank             6312 non-null   float64
#  18  popularity       6668 non-null   int64  
#  19  members          6668 non-null   int64  
#  20  favorites        6668 non-null   int64  
#  21  background       813 non-null    object 
#  22  premiered        2966 non-null   object 
#  23  broadcast        2980 non-null   object 
#  24  related          6668 non-null   object 
#  25  producer         4402 non-null   object 
#  26  licensor         2787 non-null   object 
#  27  studio           6668 non-null   object 
#  28  genre            6664 non-null   object 
#  29  opening_theme    6668 non-null   object 
#  30  ending_theme     6668 non-null   object 
#  31  duration_min     6668 non-null   float64
#  32  aired_from_year  6668 non-null   int64 

# Note: There is a lot of categorical data...

# %%
# 1. Is a Rating Score of 6.2 Different from the Mean in this Dataset?
    # Use the variable score.

# Notes: Because this is comparing a sample mean to a population mean, 
    # I'll use a single sample t-test

    # Step 1: test assumptions – the data are normally distributed
anime.score.hist()

# %%
# Note: These data are roughly normally distributed

    # Step 2: Run analysis
stats.ttest_1samp(anime.score, 6.2)

# %%
# Output: Ttest_1sampResult(statistic=57.14153988539698, pvalue=0.0)
    # Note: This p value is lower than 0.05, which means there is a
    # significant difference between a 6.2 score and the mean score
    # for the data – but we don't yet know if 6.2 is higher or lower
    # than the mean

    # Step 3: Find average score for dataset
anime.score.mean()

# %%
# Output: 6.848998200359939
    # Note: This means that 6.2 is a significantly lower rating score
    # than the average score of 6.8



# %%
# 2. Does Anime that is Still Airing Differ in Popularity from Anime 
        # that is No Longer Airing?
    # Use the variables status and popularity.

# Notes: Because this is comparing the means of two unrelated groups,
    # AND because the status variable is categorical and the 
    # popularity variable is continuous, I'll use an independent t
    # test

    # Step 1 – test assumptions: the data are normally distributed
anime.popularity[anime.status == 'Currently Airing'].hist()

# %%
# Note: These data are not normally distributed, but, as with many
    # of the practice examples in this lesson, we'll test anyway

anime.popularity[anime.status == 'Finished Airing'].hist()

# %%
# Note: These data are also not normally distributed.. see above ;)

    # Step 2 – Run the analysis
ttest_ind(anime.popularity[anime.status == 'Currently Airing'], anime.popularity[anime.status == 'Finished Airing'])

# %%
# Output:
# Ttest_indResult(statistic=6.489071311277514, 
    # pvalue=9.256789141747445e-11)

# Note: This p value is lower than 0.05, which means there is a 
    # significant difference in popularity between anime that is 
    # currently airing and anime that has finished airing, though
    # not which is higher or lower in popularity (logic says currently
    # airing anime is more popular...)

    # Step 3 - Group by status to find mean popularity for each
anime.groupby('status')['popularity'].mean()

# %%
# Output:
# status
    # Currently Airing    6108.131148
    # Finished Airing     4433.558057
    # Name: popularity, dtype: float64

# Note: This means that, as expected, currently airing anime is 
    # significantly more popular than anime that has finished airing



# %%
# 3. Does the Source of the Anime Influence the Type of Anime?
    # Use the variable source, recoded to have four levels:
        # Manga
        # Book
        # Game
        # Listening
    # And use the variable type.

# Notes: Because this determine whether two categorical variables 
    # influence each other, AND because the source and type variables 
    # are both categorical, I'll use an independent Chi Square test

    # Step 1 - recode source variable
anime.source.unique()

# %%
# Output:
# array(['Manga', 'Original', 'Light novel', '4-koma manga', 
    # 'Novel', 'Visual novel', 'Other', 'Game', 'Picture book', 
    # 'Card game', 'Web manga', 'Book', 'Music', 'Radio', 
    # 'Digital manga'], dtype=object)

def anime_source (sourceType):
		if sourceType == 'Original':
			return ''
        
		if sourceType == 'Light novel':
			return 'Book'

		if sourceType == '4-koma manga':
			return 'Manga'

		if sourceType == 'Novel':
			return 'Book'

		if sourceType == 'Visual novel':
			return 'Book'

		if sourceType == 'Other':
			return ''

		if sourceType == 'Picture book':
			return 'Book'

		if sourceType == 'Card game':
			return 'Game'

		if sourceType == 'Web manga':
			return 'Manga'

		if sourceType == 'Music':
			return 'Listening'

		if sourceType == 'Radio':
			return 'Listening'

		if sourceType == 'Digital manga':
			return 'Manga'

		else:
			return ''

anime['sourceR'] = anime['source'].apply(anime_source)

anime.sourceR.unique()

# %%
    # Step 2 - create crosstab
animeCrosstab = pd.crosstab(anime.sourceR, anime.type)

animeCrosstab

# %%
# Note: This does include empty values, but I couldn't figure out 
    # how to remove them (.dropna() didn't work, and neither did
    # my attempts to create a new variable which only includes rows 
    # where source != '')

# %%
    # Step 3 - Step 2 - run Chi-Square test AND test assumption (at 
        # least 5 cases per cell)
stats.chi2_contingency(animeCrosstab)

# %%
# Output:
# (2153.608299172365,
#  0.0,
#  20,
#  array([[6.70106179e+02, 7.23242352e+01, 3.01104979e+02, 9.92613227e+02,
#          6.85604229e+02, 2.19924715e+03],
#         [1.80973605e+02, 1.95323935e+01, 8.13185363e+01, 2.68072136e+02,
#          1.85159118e+02, 5.93944211e+02],
#         [6.26394721e+00, 6.76064787e-01, 2.81463707e+00, 9.27864427e+00,
#          6.40881824e+00, 2.05578884e+01],
#         [8.17036593e+00, 8.81823635e-01, 3.67126575e+00, 1.21025795e+01,
#          8.35932813e+00, 2.68146371e+01],
#         [4.24859028e+01, 4.58548290e+00, 1.90905819e+01, 6.29334133e+01,
#          4.34685063e+01, 1.39436113e+02]]))

# Note: This p value (0.0) is less than 0.05, which WOULD mean that 
    # the source of anime does significantly influence the type...
    # EXCEPT that many values in the array are below 5, which means
    # not all of these data meet the necessary assumptions for this
    # test to be reliable



# %%
# 4. How do the Variables about Popularity / Ranking Relate to Each 
        # Other?
    # Use the following variables:
        # score
        # scored_by
        # rank
        # popularity
        # members
        # favorites

# Notes: Because this is determining how related two variables are,
    # AND because the variables are all continuous, I'll use a 
    # correlation test

    # Step 1 - drop categorical data
anime1 = anime[['anime_id', 'episodes', 'score', 'scored_by', 'rank', 'popularity', 'members', 'favorites', 'duration_min']]

# %%
    # Step 2 - drop NA's
anime1.dropna(inplace=True)

anime1.head()

# %%
    # Step 3 - create a heatmap
sns.heatmap(anime1.corr(), annot=True)

# %%
# Note: Too hard to read the numbers

    # Step 4 - create a correlation matrix... pretty, of course
anime1.corr().style.format('{:.2}').background_gradient(cmap = plt.get_cmap('coolwarm'), axis = 1)

# %%
# Note: There are a handful of moderate and strong, positive
    # correlations - most notably:
    # members and scored_by (0.99)
    # favorites and scored_by (0.79)
    # favorites and members (0.78)
    # popularity and rank (0.78)