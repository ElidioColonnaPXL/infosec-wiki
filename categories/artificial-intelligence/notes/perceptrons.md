introduction to Deep Learning

The `perceptron` is a fundamental building block of neural networks. It is a simplified model of a biological neuron that can make basic decisions.
## Structure of a Perceptron


A perceptron consists of the following components:

- `Input Values (x1​, x2​, ..., xn​):` These are the initial data points fed into the perceptron. Each input value represents a feature or attribute of the data.
- `Weights (w1, w2, ..., wn):` Each input value is associated with a weight, determining its strength or importance. Weights can be positive or negative and influence the output of the perceptron.
- `Summation Function (∑):` The weighted inputs are summed together as `∑(wi * xi)` . This step aggregates the weighted inputs into a single value.
- `Bias (b):` A bias term is added to the weighted sum to shift the activation function. It allows the perceptron to activate even when all inputs are zero.
- `Activation Function (f):` The activation function introduces non-linearity into the perceptron. It takes the weighted sum plus the bias as input and produces an output based on a predefined threshold.
- `Output (y):` The final output of the perceptron, typically a binary value (0 or 1) representing a decision or classification.

## Deciding to Play Tennis

- `Outlook`: Sunny (0), Overcast (1), Rainy (2)
- `Temperature`: Hot (0), Mild (1), Cool (2)
- `Humidity`: High (0), Normal (1)
- `Wind`: Weak (0), Strong (1)

Our perceptron will take these inputs and output a binary decision: `Play Tennis` (1) or `Don't Play Tennis` (0).

For simplicity, let's assume the following weights and bias:

- `w1` (Outlook) = 0.3
- `w2` (Temperature) = 0.2
- `w3` (Humidity) = -0.4
- `w4` (Wind) = -0.2
- `b` (Bias) = 0.1

We'll use a simple step activation function:

Code: python

```python
f(x) = 1 if x > 0, else 0
```

Implemented in Python, like this:

Code: python

```python
def step_activation(x):
  """Step activation function."""
  return 1 if x > 0 else 0
```

Now, let's consider a day with the following conditions:

- `Outlook`: Sunny (0)
- `Temperature`: Mild (1)
- `Humidity`: High (0)
- `Wind`: Weak (0)

The perceptron calculates the weighted sum:

Code: python

```python
(0.3 * 0) + (0.2 * 1) + (-0.4 * 0) + (-0.2 * 0) = 0.2
```

Adding the bias:

Code: python

```python
0.2 + 0.1 = 0.3
```

Applying the activation function:

Code: python

```python
f(0.3) = 1 (since 0.3 > 0)
```

The output is 1, so the perceptron decides to `Play Tennis`.

In Python, this looks like this:

Code: python

```python
# Input features
outlook = 0
temperature = 1
humidity = 0
wind = 0

# Weights and bias
w1 = 0.3
w2 = 0.2
w3 = -0.4
w4 = -0.2
b = 0.1

# Calculate weighted sum
weighted_sum = (w1 * outlook) + (w2 * temperature) + (w3 * humidity) + (w4 * wind)

# Add bias
total_input = weighted_sum + b

# Apply activation function
output = step_activation(total_input)

print(f"Output: {output}")  # Output: 1 (Play Tennis)
```

## The Limitations of Perceptrons
While perceptrons provide a foundational understanding of neural networks, single-layer perceptrons have significant limitations that restrict their applicability to more complex tasks.
