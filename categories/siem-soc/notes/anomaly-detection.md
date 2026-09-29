# Anomaly Detection

Fundamentals of AI


`Anomaly detection`, also known as outlier detection, is crucial in `unsupervised learning`. It identifies data points that deviate significantly from normal behavior within a dataset.

Anomalies can be broadly categorized into three types:

- `Point Anomalies:` Individual data points significantly differ from the rest—for example, a sudden spike in network traffic or an unusually high credit card transaction amount.
- `Contextual Anomalies:` Data points considered anomalous within a specific context but not necessarily in isolation. For example, a temperature reading of 30°C might be expected in summer but anomalous in winter.
- `Collective Anomalies:` A group of data points that collectively deviate from the normal behavior, even though individual data points might not be considered anomalous. For example, a sudden surge in login attempts from multiple unknown IP addresses could indicate a coordinated attack.

Various techniques are employed for anomaly detection, including:

- `Statistical Methods:` These methods assume that normal data points follow a specific statistical distribution (e.g., Gaussian distribution) and identify outliers as data points that deviate significantly from this distribution. Examples include z-score, modified z-score, and boxplots.
- `Clustering-Based Methods:` These methods group similar data points together and identify outliers as data points that do not belong to any cluster or belong to small, sparse clusters. K-Means Clustering and density-based clustering are commonly used for anomaly detection.
- `Machine Learning-Based Methods:` These methods utilize machine learning algorithms to learn patterns from normal data and identify outliers as data points that do not conform to these patterns. Examples include One-Class [SVM](../../artificial-intelligence/notes/svm.md), `Isolation Forest`, and `Local Outlier Factor (LOF)`.

### One-Class SVM


### Isolation Forest


The anomaly score for a data point `x` is calculated as:
```python
score(x) = 2^(-E(h(x)) / c(n))
```

Where:

- `E(h(x))`: Average path length of data point `x` in a collection of isolation trees.
- `c(n)`: Average path length of unsuccessful search in a Binary Search Tree (BST) with `n` nodes. This serves as a normalization factor.
- `n`: Number of data points.

Anomaly scores closer to 1 indicate a higher likelihood of being an anomaly, while scores closer to 0.5 indicate that the data point is likely normal.

### Local Outlier Factor (LOF)

`Local Outlier Factor (LOF)` is a density-based algorithm designed to identify outliers in datasets by comparing the local density of a data point to that of its neighbors.

The LOF score for a data point `p` is calculated using the following formula:
```python
LOF(p) = (Σ lrd(o) / k) / lrd(p)
```

Where:

- `lrd(p)` : The local reachability density of data point `p`.
- `lrd(o)` : The local reachability density of data point `o`, one of the `k` nearest neighbors of `p`.
- `k` : The number of nearest neighbors.

Higher LOF scores indicate a higher likelihood of a data point being an outlier.

### Local Reachability Density

The local reachability density (`lrd(p)`) for a data point `p` is defined as:

Code: python

```python
lrd(p) = 1 / (Σ reach_dist(p, o) / k)
```

- `reach_dist(p, o)`: The reachability distance from `p` to `o`, which is the maximum of the actual distance between `p` and `o` and the k-distance of `o`.

### Data Assumptions
Anomaly detection techniques often make certain assumptions about the data:

- `Normal Data Distribution:` Some methods assume that normal data points, such as Gaussian distribution, follow a specific distribution.
- `Feature Relevance:` The choice of features can significantly impact the performance of anomaly detection algorithms.
- `Labeled Data (for some methods):` Some machine learning-based methods require labeled data to train the model.
