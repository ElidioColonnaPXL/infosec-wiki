# Naive Bayes

AI Supervised learning Algorithms
Fundamentals of AI

https://youtu.be/HZGCoVF3YvM?si=xF0-mCWdBHF7qulw

explained by percentage of square
> **Missing source attachment: `Pasted image 20260303162407.png`:**


`Naive Bayes` is a probabilistic algorithm used for `classification` tasks. It's based on `Bayes' theorem`

## Bayes' Theorem
This theorem provides a way to update our beliefs about an event based on new evidence. It allows us to calculate the probability of an event, given that another event has already occurred.
```python
P(A|B) = [P(B|A) * P(A)] / P(B)
```

Where:

- `P(A|B)`: The posterior probability of event `A` happening, given that event `B` has already happened.
- `P(B|A)`: The likelihood of event `B` happening given that event `A` has already happened.
- `P(A)`: The prior probability of event `A` happening.
- `P(B)`: The prior probability of event `B` happening.

## How Naive Bayes Works
Let's break down how this works in practice:

- `Calculate Prior Probabilities:` The algorithm first calculates the prior probability of each class. This is the probability of a data point belonging to a particular class before considering its features. For example, in a spam detection scenario, the probability of an email being spam might be 0.2 (20%), while the probability of it being not spam is 0.8 (80%).
- `Calculate Likelihoods:` Next, the algorithm calculates the likelihood of observing each feature given each class. This involves determining the probability of seeing a particular feature value given that the data point belongs to a specific class. For instance, what's the likelihood of seeing the word "free" in an email given that it's spam? What's the likelihood of seeing the word "meeting" given that it's not spam?
- `Apply Bayes' Theorem:` For a new data point, the algorithm combines the prior probabilities and likelihoods using `Bayes' theorem` to calculate the `posterior probability` of the data point belonging to each class. The `posterior probability` is the updated probability of an event (in this case, the data point belonging to a certain class) after considering new information (the observed features). This represents the revised belief about the class label after considering the observed features.
- `Predict the Class:` Finally, the algorithm assigns the data point to the class with the highest posterior probability.

While this assumption of feature independence is often violated in real-world data (words like "free" and "viagra" might indeed co-occur more often in spam), `Naive Bayes` often performs surprisingly well in practice.

### Types of Naive Bayes Classifiers

The specific implementation of `Naive Bayes` depends on the type of features and their assumed distribution:

- `Gaussian Naive Bayes:` This is used when the features are continuous and assumed to follow a Gaussian distribution (a bell curve). For example, if predicting whether a customer will purchase a product based on their age and income, `Gaussian Naive Bayes` could be used, assuming age and income are normally distributed.
- `Multinomial Naive Bayes:` This is suitable for discrete features and is often used in text classification. For instance, in spam filtering, the frequency of words like "free" or "money" might be the features, and `Multinomial Naive Bayes` would model the probability of these words appearing in spam and non-spam emails.
- `Bernoulli Naive Bayes:` This type is employed for binary features, where the feature is either present or absent. In document classification, a feature could be whether a specific word is present in the document. `Bernoulli Naive Bayes` would model the probability of this presence or absence for each class.

## Data Assumptions

While Naive Bayes is relatively robust, it's helpful to be aware of some data assumptions:

- `Feature Independence:` As discussed, the core assumption is that features are conditionally independent given the class.
- `Data Distribution:` The choice of Naive Bayes classifier (Gaussian, Multinomial, Bernoulli) depends on the assumed distribution of the features.
- `Sufficient Training Data:` Although Naive Bayes can work with limited data, it is important to have sufficient data to estimate probabilities accurately.
