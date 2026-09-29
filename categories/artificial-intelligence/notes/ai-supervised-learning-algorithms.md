Fundamentals of AI

# Supervised Learning


Supervised learning uses **labeled data** to train models that can predict outcomes for new, unseen inputs.
Each example consists of:

- **Features (input variables)**

- **Label (correct output)**


The algorithm learns a **mapping function** between features and labels to generalize to new data.

---

## 1. Types of Supervised Learning

|Type|Goal|Example|
|---|---|---|
|Classification|Predict a categorical label|Spam vs not spam, image class|
|Regression|Predict a continuous value|House price, temperature|

---

## 2. How It Works (Analogy)

Like teaching a child:

1. Show example + correct answer

2. Repeat with many examples

3. The learner recognizes patterns

4. The learner predicts new cases


The algorithm adjusts its internal parameters to **minimize prediction error**.

---

## 3. Core Concepts – Overview Table

|Concept|Short Explanation|
|---|---|
|Training Data|Labeled dataset used to teach the model|
|Features|Measurable input variables used for prediction|
|Labels|Known correct outputs in training data|
|Model|Mathematical function mapping features → labels|
|Training|Process of adjusting model to reduce error|
|Prediction|Using trained model to output a label/value|
|Inference|Broader reasoning using the trained model|
|Evaluation|Measuring model quality with metrics|
|Generalization|Ability to perform well on new data|
|Overfitting|Model learns noise instead of patterns|
|Underfitting|Model too simple to capture patterns|
|Cross-Validation|Technique to test generalization|
|Regularization|Methods to reduce overfitting|

---

## 4. Detailed Concept Notes

### Training Data

- Foundation of supervised learning

- Contains **inputs + correct answers**

- Quality and size determine performance


### Features

- Descriptive attributes of data

- Example for house prices:

    - size

    - location

    - bedrooms

    - age


### Labels

- Target value to be predicted

- Category (classification) or number (regression)


### Model

- Function learned from data

- Takes features → outputs prediction


### Training

- Iterative optimization

- Minimize difference between prediction and label


### Prediction vs Inference

- **Prediction:** produce actionable output

- **Inference:** understand relationships and importance of variables


### Evaluation Metrics

|Metric|Meaning|
|---|---|
|Accuracy|% correct predictions|
|Precision|Correct positives / predicted positives|
|Recall|Correct positives / actual positives|
|F1-score|Balance between precision and recall|

### Generalization

- Performance on **unseen data**

- Main goal of supervised learning


### Overfitting

- Model memorizes training noise

- High training accuracy, low real performance


### Underfitting

- Model too simple

- Poor performance everywhere


### Cross-Validation

- Split data into folds

- Train on some, validate on others

- Reliable performance estimate


### Regularization

|Method|Idea|
|---|---|
|L1|Penalize absolute weights|
|L2|Penalize squared weights|

Reduces model complexity and overfitting.

---

## 5. Workflow Summary

1. Collect labeled data

2. Select features

3. Train model

4. Evaluate with metrics

5. Tune with cross-validation

6. Apply regularization

7. Deploy for prediction


---

# Linear Regression

# Logistic Regression
# Decision Trees

# Naive Bayes

# [SVM](svm.md)
