Fundamentals of AI

# Introduction to Deep Learning – Core Concepts

Deep Learning (DL) is a specialized branch of machine learning that uses **multi-layer neural networks** to learn complex patterns directly from raw data.
The term _deep_ refers to the presence of many processing layers.

Key characteristics:

- Automatic feature learning

- Hierarchical representations

- High performance on complex data

- Inspired by the human brain


---

## 1. Position in AI Landscape

|Level|Role|
|---|---|
|Artificial Intelligence|Goal of intelligent behavior|
|Machine Learning|Learning from data|
|Deep Learning|Neural networks with many layers|

Deep learning differs from traditional ML by **eliminating manual feature engineering**.

---

## 2. Motivation for Deep Learning

|Goal|Explanation|
|---|---|
|Solve Complex Problems|Handle images, speech, language|
|Brain Inspiration|Hierarchical information processing|
|Scalability|Use of large datasets|
|Automation|Learn features automatically|

---

## 3. Core Concepts – Overview Table

|Concept|Short Explanation|
|---|---|
|ANN|Network of artificial neurons|
|Layers|Structured levels of computation|
|Activation Function|Introduces non-linearity|
|Backpropagation|Learning algorithm|
|Loss Function|Measures prediction error|
|Optimizer|Updates network weights|
|Hyperparameters|Settings before training|

---

## 4. Artificial Neural Networks (ANN)

- Inspired by biological neurons

- Nodes connected with weights

- Learning = adjusting weights

- Capable of modeling complex relations


---

## 5. Layer Structure

|Layer Type|Function|
|---|---|
|Input Layer|Receives raw data|
|Hidden Layers|Extract features|
|Output Layer|Produces prediction|

Multiple hidden layers enable **hierarchical learning**.

---

## 6. Activation Functions

|Function|Behavior|
|---|---|
|Sigmoid|Output between 0 and 1|
|ReLU|0 for negative, linear for positive|
|Tanh|Output between -1 and 1|

Activation adds non-linearity, allowing complex modeling.

---

## 7. Training Mechanisms

### Backpropagation

- Compute gradient of error

- Propagate error backwards

- Update weights iteratively


### Loss Function

|Task|Common Loss|
|---|---|
|Regression|Mean Squared Error|
|Classification|Cross-Entropy|

Measures difference between prediction and truth.

---

## 8. Optimizers

|Optimizer|Idea|
|---|---|
|SGD|Basic gradient descent|
|Adam|Adaptive learning rates|
|RMSprop|Stable updates|

Control how weights are changed.

---

## 9. Hyperparameters

Examples:

- Learning rate

- Number of layers

- Neurons per layer

- Batch size

- Epochs


Must be chosen before training.

---

## 10. Why Deep Learning Matters

- Image recognition

- Speech processing

- Natural language

- Robotics

- Scientific discovery


DL enables AI systems to learn **directly from raw, unstructured data**.

---

## 11. Learning Workflow

1. Define architecture

2. Choose loss and optimizer

3. Train with backpropagation

4. Tune hyperparameters

5. Evaluate performance

# [Perceptrons](perceptrons.md)
# Neural Networks

# Convolutional Neural Networks

# Recurrent Neural Networks
