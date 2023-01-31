# %%
# DSO105 - Intermediate Statistics
    # Lesson 1 - Basic Statistics in Python

# Page 15 - Correlation Activity

# Requirements: Using the power_lifting dataset, you will explore how
    # the different variables are related with each other. Use any
    # means of correlation you like, and correlate any variables you
    # like. Make sure to note anything interesting or unusual that
    # stands out to you, and interpret those correlations.

# %%
# Import packages
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# %%
# Import and preview data
iworkout = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/power_lifting.csv')

iworkout.head()


# %%
# Step 1 - drop categorical data
iworkout1 = iworkout.drop(['MeetID', 'Name', 'Sex', 'Equipment', 'Division'], axis = 1)


# %%
# Step 2 - drop NA's
iworkout1.dropna(inplace=True)

iworkout1.head()


# %%
# Step 3 - create a heatmap
sns.heatmap(iworkout1.corr(), annot=True)

# %%
# Note: Too hard to read the numbers


# %%
# Step 4 - create a correlation matrix... pretty, of course
iworkout1.corr().style.format('{:.2}').background_gradient(cmap = plt.get_cmap('coolwarm'), axis = 1)

# %%
# Note: There are a fair amount of moderate and strong, positive
    # correlations - most notably:
    # TotalKg and BestSquatKg (0.98)
    # TotalKg and BestBenchKg (0.97)
    # TotalKg and BestDeadliftKg (0.97)