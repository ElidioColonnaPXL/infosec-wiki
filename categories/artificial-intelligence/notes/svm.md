- [ ] Fundamentals of AI

# Support Vector Machines (SVMs)

`Support Vector Machines` (SVMs) are powerful `supervised learning` algorithms for `classification` and `regression` tasks.
They are particularly effective in handling high-dimensional data and complex non-linear relationships between features and the target variable.
SVMs aim to find the optimal `hyperplane` that maximally separates different classes or fits the data for regression.

## Linear SVM

A `linear SVM` is used when the data is linearly separable, meaning a straight line or hyperplane can perfectly separate the classes. The goal is to find the optimal hyperplane that maximizes the margin while correctly classifying all the training data points.

### Finding the Optimal Hyperplane
Imagine you're tasked with classifying emails as spam or not spam based on the frequency of the words "free" and "money."
If we plot each email on a graph where the x-axis represents the frequency of "free" and the y-axis represents the frequency of "money,"
we can visualize how SVMs work.

The `optimal hyperplane` is the one that maximizes the margin between the closest data points of different classes. This margin is called the `separating hyperplane`

The hyperplane is defined by an equation of the form:

Code: python

```python
w * x + b = 0
```

Where:

- `w` is the weight vector, perpendicular to the hyperplane.
- `x` is the input feature vector.
- `b` is the bias term, which shifts the hyperplane relative to the origin.

The SVM algorithm learns the optimal values for `w` and `b` during the training process.

## Non-Linear SVM

In many real-world scenarios, data is not linearly separable. This means we cannot draw a straight line or hyperplane to perfectly separate the different classes. In these cases, `non-linear SVMs` come to the rescue.

### Kernel Functions

Several kernel functions are commonly used in `non-linear SVMs`:

- `Polynomial Kernel:` This kernel introduces polynomial terms (like x², x³, etc.) to capture non-linear relationships between features. It's like adding curves to the decision boundary.
- `Radial Basis Function (RBF) Kernel:` This kernel uses a Gaussian function to map data points to a higher-dimensional space. It's one of the most popular and versatile kernel functions, capable of capturing complex non-linear patterns.
- `Sigmoid Kernel:` This kernel is similar to the sigmoid function used in logistic regression. It introduces non-linearity by mapping the data points to a space with a sigmoid-shaped decision boundary.

### Image Classification
`Non-linear SVMs` are particularly useful in applications like image classification. Images often have complex patterns that linear boundaries cannot separate.

## The SVM Function

Finding this optimal hyperplane involves solving an optimization problem. The problem can be formulated as:
```python
Minimize: 1/2 ||w||^2
Subject to: yi(w * xi + b) >= 1 for all i
```
Where:
- `w` is the weight vector that defines the hyperplane
- `xi` is the feature vector for data point `i`
- `yi` is the class label for data point `i` (-1 or 1)
- `b` is the bias term

## Data Assumptions
- `No Distributional Assumptions:` SVMs do not make strong assumptions about the underlying distribution of the data.
- `Handles High Dimensionality:` They are effective in high-dimensional spaces, where the number of features is larger than the number of data points.
- `Robust to Outliers:` SVMs are relatively robust to outliers, focusing on maximizing the margin rather than fitting all data points perfectly.
