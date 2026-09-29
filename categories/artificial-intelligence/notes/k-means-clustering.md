# K-Means Clustering

Fundamentals of AI


The algorithm follows these steps:

1. `Initialization:` Randomly select `K` data points from the dataset as the initial cluster centers (centroids). These centroids represent the average point within each cluster.
2. `Assignment:` Assign each data point to the nearest cluster center based on a distance metric, such as `Euclidean distance`.
3. `Update:` Recalculate the cluster centers by taking the mean of all data points assigned to each cluster. This updates the centroid to represent the center of the cluster better.
4. `Iteration:` Repeat steps 2 and 3 until the cluster centers no longer change significantly or a maximum number of iterations is reached. This iterative process refines the clusters until they stabilize.
5.

## Euclidean Distance

`Euclidean distance` is a common distance metric used to measure the similarity between data points in `K-means clustering`. It calculates the straight-line distance between two points in a multi-dimensional space.

For two data points `x` and `y` with `n` features, the `Euclidean distance` is calculated as:

Code: python

```python
d(x, y) = sqrt(Σ (xi - yi)^2)
```

Where:

- `xi` and `yi` are the values of the `i`-th feature for data points `x` and `y`, respectively.

## Choosing the Optimal K

Determining the optimal number of clusters (`K`) is crucial in `K-means clustering`.
### Elbow Method

It follows the following steps:

1. `Run K-means for a range of K values:` Perform `K-means clustering` for different values of `K`, typically starting from 1 and increasing incrementally.
2. `Calculate WCSS:` For each value of `K`, calculate the WCSS. The WCSS measures the total variance within each cluster. Lower WCSS values indicate that the data points within clusters are more similar.
3. `Plot WCSS vs. K:` Plot the WCSS values against the corresponding `K` values.
4. `Identify the Elbow Point:` Look for the "elbow" point in the plot. This is where the WCSS starts to decrease at a slower rate. This point often suggests a good value for `K`, indicating a balance between minimizing within-cluster variance and avoiding excessive granularity.

### Silhouette Analysis

The process is broken down into four core steps:

1. `Run K-means for a range of K values:` Similar to the elbow method, perform `K-means clustering` for different values of `K`.
2. `Calculate Silhouette Scores:` For each data point, calculate its silhouette score. The silhouette score ranges from -1 to 1, where:
    - A score close to 1 indicates that the data point is well-matched to its cluster and poorly matched to neighboring clusters.
    - A score close to 0 indicates that the data point is on or very close to the decision boundary between two neighboring clusters.
    - A score close to -1 indicates that the data point is probably assigned to the wrong cluster.
3. `Calculate Average Silhouette Score:` For each value of `K`, calculate the average silhouette score across all data points.
4. `Choose K with the Highest Score:` Select the value of `K` that yields the highest average silhouette score. This indicates the clustering solution with the best-defined clusters.

### Domain Expertise and Other Considerations
Consider the problem's specific context and the desired level of granularity in the clusters.
Other factors to consider include:

- `Computational Cost:` Higher values of `K` generally require more computational resources.
- `Interpretability:` The resulting clusters should be meaningful and interpretable in the context of the problem.


## Data Assumptions

`K-means clustering` makes certain assumptions about the data:
- `Cluster Shape:` It assumes that clusters are spherical and have similar sizes. This means it might not perform well if the clusters have complex shapes or vary significantly in size.
- `Feature Scale:` It is sensitive to the scale of the features. Features with larger scales can have a greater influence on the clustering results. Therefore, it's important to standardize or normalize the data before applying `K-means`.
- `Outliers:` `K-means` can be sensitive to outliers, data points that deviate significantly from the norm. Outliers can distort the cluster centers and affect the clustering results.
