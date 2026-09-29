# Unsupervised Learning

Unsupervised learning analyzes **unlabeled data** to discover hidden structure without predefined outcomes.
The objective is exploration rather than prediction.

Main goals:

- Find patterns and relationships

- Group similar data

- Reduce complexity

- Detect unusual behavior


---

## 1. Categories of Unsupervised Learning

| Category                 | Purpose             | Example               |
| ------------------------ | ------------------- | --------------------- |
| K-Means Clustering   | Group similar items | Customer segmentation |
| Dimensionality Reduction | Compress features   | Image compression     |
| Anomaly Detection    | Find abnormal cases | Fraud detection       |

---

## 2. How It Works (Intuition)

Like exploring a city without a map:

1. Observe similarities

2. Notice natural groupings

3. Identify landmarks

4. Detect unusual locations


Algorithms rely only on **data characteristics**, not on correct answers.

---

## 3. Core Concepts – Overview Table

|Concept|Short Explanation|
|---|---|
|Unlabeled Data|Data without target outcomes|
|Similarity Measure|Method to compare data points|
|Clustering Tendency|Natural ability to form groups|
|Cluster Validity|Quality assessment of clusters|
|Dimensionality|Number of features in data|
|Intrinsic Dimensionality|True underlying information|
|Anomaly|Unusual or rare observation|
|Outlier|Extreme data point|
|Feature Scaling|Normalizing feature ranges|

---

## 4. Detailed Concept Notes

### Unlabeled Data

- No correct answers provided

- Algorithm must infer structure

- Typical in real-world raw datasets


### Similarity Measures

|Measure|Idea|
|---|---|
|Euclidean Distance|Straight-line distance|
|Cosine Similarity|Angle between vectors|
|Manhattan Distance|Sum of absolute differences|

Choice depends on data type and algorithm.

---

### Clustering Tendency

- Determines if groups truly exist

- Uniform data may not cluster well

- Important pre-analysis step


---

### Cluster Validity

|Metric|Meaning|
|---|---|
|Cohesion|Similarity within cluster|
|Separation|Difference between clusters|
|Silhouette|Balance of both|
|Davies-Bouldin|Cluster quality index|

---

### Dimensionality Issues

- High dimensions → sparse data

- Increased computational cost

- Distances become less meaningful

- Known as **curse of dimensionality**


---

### Intrinsic Dimensionality

- Real information is often lower

- Many features are redundant

- Reduction preserves essential structure


---

### Anomalies and Outliers

|Term|Focus|
|---|---|
|Anomaly|Deviates from pattern|
|Outlier|Far from majority|
|Use cases|Fraud, security, errors|

---

### Feature Scaling

|Method|Result|
|---|---|
|Min-Max|Fixed range|
|Standardization|Mean 0, variance 1|

Essential because distance-based algorithms are sensitive to scale.

---

## 5. Practical Workflow

1. Collect raw unlabeled data

2. Scale features

3. Check clustering tendency

4. Apply algorithm

5. Validate structure

6. Interpret results


---

## 6. When to Use Unsupervised Learning

- No labels available

- Need data exploration

- Discover hidden segments

- Detect abnormal behavior

- Reduce complexity

# K-Means Clustering
# [PCA](pca.md)
# Anomaly Detection
