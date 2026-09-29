# Linear Regression

AI Supervised learning Algorithms
Logistic Regression
Fundamentals of AI


Examples of regression problems include:

- Predicting the price of a house based on its size, location, and age.
- Forecasting the daily temperature based on historical weather data.
- Estimating the number of website visitors based on marketing spend and time of year.

## Simple Linear Regression
```python
y = mx + c
```
- `y` is the predicted target variable
- `x` is the predictor variable
- `m` is the slope of the line (representing the relationship between x and y)
- `c` is the y-intercept (the value of y when x is 0)

## Multiple Linear Regression
```python
y = b0 + b1x1 + b2x2 + ... + bnxn
```
- `y` is the predicted target variable
- `x1`, `x2`, ..., `xn` are the predictor variables
- `b0` is the y-intercept
- `b1`, `b2`, ..., `bn` are the coefficients representing the relationship between each predictor variable and the target variable.

## Ordinary Least Squares


`Ordinary Least Squares` (OLS) is a common method for estimating the optimal values for the coefficients in linear regression.
Here's a breakdown of the OLS process:

1. `Calculate Residuals:` For each data point, the `residual` is the difference between the actual `y` value and the `y` value predicted by the model.
2. `Square the Residuals:` Each residual is squared to ensure that all values are positive and to give more weight to larger errors.
3. `Sum the Squared Residuals:` All the squared residuals are summed to get a single value representing the model's overall error. This sum is called the `Residual Sum of Squares` (RSS).
4. `Minimize the Sum of Squared Residuals:` The algorithm adjusts the coefficients to find the values that result in the smallest possible RSS.

## Assumptions of Linear Regression
- `Linearity:` A linear relationship exists between the predictor and target variables.
- `Independence:` The observations in the dataset are independent of each other.
- `Homoscedasticity:` The variance of the errors is constant across all levels of the predictor variables. This means the spread of the residuals should be roughly the same across the range of predicted values.
- `Normality:` The errors are normally distributed. This assumption is important for making valid inferences about the model's coefficients.
