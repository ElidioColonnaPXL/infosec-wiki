Fundamentals of AI

# Principal Component Analysis (PCA)

`Principal Component Analysis` (PCA) is a dimensionality reduction technique that transforms high-dimensional data into a lower-dimensional representation while preserving as much original information as possible.

Think of it as finding the most important "directions" in the data. Imagine a scatter plot of data points. PCA finds the lines that best capture the spread of the data. These lines represent the principal components.


There are three key concepts to PCA:

- `Variance:` Variance measures the spread or dispersion of data points around the mean. PCA aims to find principal components that maximize variance, capturing the most significant information in the data.
- `Covariance:` Covariance measures the relationship between two variables. PCA considers the covariance between different features to identify the directions of maximum variance.
- `Eigenvectors and Eigenvalues:` Eigenvectors represent the directions of the principal components, and eigenvalues represent the amount of variance explained by each principal component.

The PCA algorithm follows these steps:

1. `Standardize the data:` Subtract the mean and divide by the standard deviation for each feature to ensure that all features have the same scale.
2. `Calculate the covariance matrix:` Compute the covariance matrix of the standardized data, which represents the relationships between different features.
3. `Compute the eigenvectors and eigenvalues:` Determine the eigenvectors and eigenvalues of the covariance matrix. The eigenvectors represent the directions of the principal components, and the eigenvalues represent the amount of variance explained by each principal component.
4. `Sort the eigenvectors:` Sort the eigenvectors in descending order of their corresponding eigenvalues. The eigenvectors with the highest eigenvalues capture the most variance in the data.
5. `Select the principal components:` Choose the top `k` eigenvectors, where `k` is the desired number of dimensions in the reduced representation.
6. `Transform the data:` Project the original data onto the selected principal components to obtain the lower-dimensional representation.

## Eigenvalues and Eigenvectors
An `eigenvector` is a special vector that remains in the same direction when a linear transformation (such as multiplication by a matrix) is applied to it. Mathematically, if `A` is a square matrix and `v` is a non-zero vector, then `v` is an eigenvector of `A` if:
```python
A * v = λ * v
```

Here, `λ` (lambda) is the eigenvalue associated with the eigenvector `v`.


Code: python

```python
A = [[2, 0],
     [0, 1]]
```

When we multiply the matrix `A` by the vector `v`, we get:

Code: python

```python
A * v = [[2, 0],
         [0, 1]] * [1, 0] = [2, 0]
```

### The Eigenvalue Equation in Principal Component Analysis (PCA)
```python
C * v = λ * v
```

Where:

- `C` is the standardized data's covariance matrix. This matrix represents the relationships between different features, with each element indicating the covariance between two features.
- `v` is the eigenvector. Eigenvectors represent the directions of the principal components in the feature space, indicating the directions of maximum variance in the data.
- `λ` is the eigenvalue. Eigenvalues represent the amount of variance explained by each corresponding eigenvector (principal component). Larger eigenvalues correspond to eigenvectors that capture more variance.

### Solving the Eigenvalue Equation
- `Eigenvalue Decomposition`: Directly computing the eigenvalues and eigenvectors.
- `Singular Value Decomposition (SVD)`: A more numerically stable method that decomposes the data matrix into singular vectors and singular values related to the eigenvectors and eigenvalues of the covariance matrix.

### Selecting Principal Components
```python
Y = X * V
```

Where:

- `Y` is the transformed data matrix in the lower-dimensional space.
- `X` is the original data matrix.
- `V` is the matrix of selected eigenvectors.

## Data Assumptions
PCA makes certain assumptions about the data:

- `Linearity:` It assumes that the relationships between features are linear.
- `Correlation:` It works best when there is a significant correlation between features.
- `Scale:` It is sensitive to the scale of the features, so it is important to standardize the data before applying PCA.
