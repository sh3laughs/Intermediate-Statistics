# %%
# DSO105 - Intermediate Statistics
    # Lesson 1 - Basic Statistics in Python

# Page 12 - Independent Chi-Square Activity

# Requirements:Using the lipstick dataset you worked with in the
    # lesson, determine if the shade of lipstick and the price
    # category are related. To do this, you will need to:

# Import packages
import pandas as pd
from scipy import stats

# %%
# Import and preview data
lipstick = pd.read_csv('/Users/hannah/Library/CloudStorage/GoogleDrive-gracesnouveaux@gmail.com/My Drive/Bethel Tech/Data Science/DSO105 Intermediate Statistics/Lesson 1. Basic Statistics in Python/lead_lipstick.csv')

lipstick.head()

# %%
        # Create a contingency table
lipstickCrosstab = pd.crosstab(lipstick.shade, lipstick.priceCatgry)

# %%
# Viewed crosstab in variable explorer:
    # shade	 1	 2	 3
    # Brown	20	30	10
    # Pink	20	49	12
    # Purple	 8	23	 6
    # Red	 5	33	 7


        # Test for the assumption of 5 per cell in the expected
            # contingency table
        # Compute an independent Chi-Square
stats.chi2_contingency(lipstickCrosstab)

# %%
# (7.860569553614045,
#  0.2484973879479863,
#  6,
#  array([[14.26008969, 36.32286996,  9.41704036],
#         [19.25112108, 49.03587444, 12.71300448],
#         [ 8.79372197, 22.39910314,  5.80717489],
#         [10.69506726, 27.24215247,  7.06278027]]))
    # Note: The p value (0.2484973879479863) is greater than 0.05,
            # which means there is no significant difference in cost
            # by shade of lipstick
        # The array also validates the assumption of a value ≥5 per
            # cell in crosstab