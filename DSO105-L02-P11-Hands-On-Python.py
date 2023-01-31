# %%
# DSO105 - Intermediate Statistics
    # Lesson 2 - When Data Isn't Normal

# Page 11 - Python Hands-On

# Requirements: This hands on uses a dataset about the number of trips 
    # done at the Seattle Parks and Recreation department. It is 
    # located here. For each part, assess and transform the requested 
    # data, then submit your annotated program files for review.

# Part I: Transforming Data in Python
    # In Python, assess the skew of the distribution and then transform 
        # it if necessary for the following variables:
            # # of trips Winter
                # Conclusion: 
                    # Positively skewed
                    # Use square root
            # # of participants Winter
                # Conclusion: 
                    # Positively skewed
                    # Use square root
            # # of trips Spring
                # Conclusion: 
                    # Positively skewed
                    # Use log
            # # of participants Spring
                # Conclusion: 
                    # Positively skewed
                    # Use square root
            # # of trips Summer
                # Conclusion: 
                    # Positively skewed
                    # Use square root
            # # of participants Summer
                # Conclusion: 
                    # Positively skewed
                    # Use square root
    # Please make notes about each variable's distribution and the 
        # transformation you made in your Python file and submit.

# %%
# Import packages
import pandas as pd
import numpy as np
import seaborn as sns
from scipy import stats
from scipy.stats import boxcox
from scipy.stats import norm

# %%
# Import and preview data
seattlePnr = pd.read_csv("/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 2. When Data Isn't Normal/Seattle_ParksnRec.csv")

seattlePnr.head()


# %%
# Preview histograms for full dataset
sns.pairplot(seattlePnr)

# %%
# Distribution of '# of trips Winter' appears to be negatively kurtotic
    # ... which we didn't learn how to transform... checking with a 
    # best fit line to see if it's actually (also?) positively skewed
sns.distplot(seattlePnr['# of trips Winter'])

# %%
# I guess it's slightly positively skewed, though the dip in the
    # midde is throwing me off...

# Transform
seattlePnr['tripsWintSqrt'] = np.sqrt(seattlePnr['# of trips Winter'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.tripsWintSqrt)

# %%
# A little better... use this (confirmed after checking log)

# Transform again
seattlePnr['tripsWintLog'] = np.log(seattlePnr['# of trips Winter'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.tripsWintLog)

# %%
# Worse - so would use square root


# %%
# Distribution of '# of participants Winter' is positively skewed 
    # (though it also has that dip...)

# Transform
seattlePnr['partsWintSqrt'] = np.sqrt(seattlePnr['# of participants Winter'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.partsWintSqrt)

# %%
# Better! Use this (confirmed after checking log)

# Transform again
seattlePnr['partsWintLog'] = np.log(seattlePnr['# of participants Winter'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.partsWintLog)

# %%
# Worse - so would use square root


# %%
# Distribution of '# of trips Spring' is positively skewed

# Transform
seattlePnr['tripsSprgSqrt'] = np.sqrt(seattlePnr['# of trips Spring'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.tripsSprgSqrt)

# %%
# A little better

# Transform again
seattlePnr['tripsSprgLog'] = np.log(seattlePnr['# of trips Spring'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.tripsSprgLog)

# %%
# Even better - use this


# %%
# Distribution of '# of participants Spring' is positively skewed (and 
    # also appears to be slightly negatively kurtotic) - it actually is 
    # very similar to '# of participants Winter'

# Transform
seattlePnr['partsSprgSqrt'] = np.sqrt(seattlePnr['# of participants Spring'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.partsSprgSqrt)

# %%
# Better - use this


# %%
# Distribution of '# of trips Summer' appears to be positively skewed, 
    # but I want to see a best fit line for it...
sns.distplot(seattlePnr['# of trips Summer'])

# %%
# It is slightly positively skewed

# Transform
seattlePnr['tripsSummSqrt'] = np.sqrt(seattlePnr['# of trips Summer'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.tripsSummSqrt)

# %%
# Better... use this (confirmed after checking log)

# Transform again
seattlePnr['tripsSummLog'] = np.log(seattlePnr['# of trips Summer'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.tripsSummLog)

# %%
# Worse - use square root


# %%
# Last, but not least, '# of participants Summer' also appears to be
    # slightly positively skewed

# Transform
seattlePnr['partsSummSqrt'] = np.sqrt(seattlePnr['# of participants Summer'])

seattlePnr.head()

# %%
# Check distribution again
sns.distplot(seattlePnr.partsSummSqrt)

# %%
# Better... use this