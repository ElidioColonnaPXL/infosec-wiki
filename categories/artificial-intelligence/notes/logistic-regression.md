# Logistic Regression

Fundamentals of AI

AI Supervised learning Algorithms
Linear Regression


Despite its name, `logistic regression` is a `supervised learning` algorithm primarily used for `classification`, not regression. It predicts a categorical target variable with two possible outcomes (binary classification). These outcomes are typically represented as binary values (e.g., 0 or 1, true or false, yes or no).

 `Classification` is a type of supervised learning that aims to assign data points to specific categories or classes.

## How Logistic Regression Works
`logistic regression` outputs a probability score between 0 and 1. This score represents the likelihood of the input belonging to the positive class (typically denoted as '1').
It achieves this by employing a `sigmoid function`, which maps any input value (a linear combination of features) to a value within the 0 to 1 range. This function introduces non-linearity,


### The Sigmoid Function
```python
P(x) = 1 / (1 + e^-z)
```
- `P(x)` is the predicted probability.
- `e` is the base of the natural logarithm (approximately 2.718).
- `z` is the linear combination of input features and their weights, similar to the linear regression equation: `z = m1x1 + m2x2 + ... + mnxn + c`

### Spam Detection

Let's say we're building a spam filter using `logistic regression`. The algorithm would analyze various email features, such as the sender's address, the presence of certain keywords, and the email's content, to calculate a probability score. The email will be classified as spam if the score exceeds a predefined threshold (e.g., 0.8).

### Decision Boundary

A crucial aspect of `logistic regression` is the `decision boundary`

## Understanding Hyperplanes

In the context of machine learning, a `hyperplane` is a subspace whose dimension is one less than that of the ambient space. It's a way to visualize a decision boundary in higher dimensions.

Think of it this way:

- A hyperplane is simply a line in a 2-dimensional space (like a sheet of paper) that divides the space into two regions.
- A hyperplane is a flat plane in a 3-dimensional space (like your room) that divides the space into two halves.

## Data Assumptions
- `Binary Outcome:` The target variable must be categorical, with only two possible outcomes.
- `Linearity of Log Odds:` It assumes a linear relationship between the predictor variables and the log-odds of the outcome.
- `No or Little Multicollinearity:` Ideally, there should be little to no `multicollinearity` among the predictor variables.
- `Large Sample Size:` Logistic regression performs better with larger datasets, allowing for more reliable parameter estimation.
