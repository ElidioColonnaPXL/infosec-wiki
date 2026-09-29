Fundamentals of AI
# Generative AI
## 1. Definition

**Generative AI** is a subfield of Machine Learning that focuses on creating new, original content that resembles human-generated data.

### Key difference from traditional AI

|Traditional AI|Generative AI|
|---|---|
|Recognizes patterns|Creates new content|
|Classifies data|Generates data|
|Makes predictions|Produces original output|
|Example: spam detection|Example: text generation, image creation|

### Examples of generated content

- Text (ChatGPT, language models)

- Images (Stable Diffusion, DALL-E)

- Music

- Code

- Video


---

## 2. Core Principle

Generative AI learns the **statistical patterns and structure** of data and uses this knowledge to generate new samples.

It does not copy data directly. Instead, it learns the **underlying distribution** and creates new content with similar characteristics.

---

## 3. How Generative AI Works

Generative AI operates in three main phases:

### 3.1 Training Phase

**Goal:** Learn patterns from a dataset.

Process:

- Model is trained on large datasets

- Learns relationships between elements

- Captures statistical properties of the data


Examples:

- Text dataset → learns grammar and structure

- Image dataset → learns shapes, textures, objects


---

### 3.2 Generation Phase

**Goal:** Create new content.

Process:

- Start with:

    - random seed, or

    - user input

- Model samples from learned distribution

- Output is refined step-by-step


Result:

- New, original content

- Similar to training data but not identical


---

### 3.3 Evaluation Phase

**Goal:** Measure quality of generated output.

Two evaluation methods:

**Subjective evaluation**

- Human judgment

- Example: Does image look realistic?


**Objective evaluation**

- Mathematical metrics

- Measure quality and diversity


---

## 4. Types of Generative AI Models

### 4.1 Generative Adversarial Networks (GANs)

Structure consists of two neural networks:

|Component|Function|
|---|---|
|Generator|Creates fake samples|
|Discriminator|Detects real vs fake samples|

Process:

- Generator creates samples

- Discriminator evaluates samples

- Both improve through competition


Result:

- Highly realistic outputs


---

### 4.2 Variational Autoencoders (VAEs)

Function:

- Learn compressed representation of data

- Generate new samples from compressed representation


Characteristics:

- Good at capturing structure

- Allows controlled generation

- Produces diverse outputs


---

### 4.3 Autoregressive Models

Function:

- Generate output sequentially

- Each element depends on previous elements


Example (text generation):

- Predict next word based on previous words


Used in:

- Language models (GPT)

- Text generation systems


---

### 4.4 Diffusion Models

Process consists of two steps:

Step 1: Add noise to data until pure noise
Step 2: Learn to reverse noise process

Generation:

- Start from noise

- Gradually refine into meaningful data


Used for:

- High-quality image generation

- Stable Diffusion, DALL-E


---

## 5. Important Generative AI Concepts

### 5.1 Latent Space

Definition:
Hidden, compressed representation of data features.

Characteristics:

- Similar data points are close together

- Different data points are far apart


Purpose:

- Used to generate new content by sampling points


---

### 5.2 Sampling

Definition:
Process of generating new data from learned distribution.

Steps:

1. Select point in latent space

2. Convert to output


Quality depends on:

- Training quality

- Accuracy of learned distribution


---

### 5.3 Mode Collapse

Definition:
Model generates limited variety of outputs.

Problem:

- Lack of diversity

- Repeated or similar outputs


Common in:

- GAN models


---

### 5.4 Overfitting

Definition:
Model learns training data too closely.

Problem:

- Poor generalization

- Low creativity

- Cannot generate truly new content


Cause:

- Model memorizes instead of learning patterns


---

## 6. Evaluation Metrics

Used to measure quality and diversity.

### Inception Score (IS)

Measures:

- Image quality

- Image diversity


Higher score = better

---

### Fréchet Inception Distance (FID)

Measures:

- Similarity between generated and real images


Lower score = better

Indicates:

- Realism

- Quality


---

### BLEU Score

Used for:

- Text generation


Measures:

- Similarity between generated and reference text


Higher score = better

Evaluates:

- Fluency

- Accuracy


---

## 7. Generative AI Workflow Overview

Training Data
↓
Learn patterns
↓
Latent space representation
↓
Sampling
↓
Generated content
↓
Evaluation (IS, FID, BLEU)

---


**Generative AI**
AI that creates new content similar to training data.

**Latent Space**
Compressed internal representation of data features.

**Sampling**
Process of generating new data from learned patterns.

**Mode Collapse**
Failure to generate diverse outputs.

**Overfitting**
Model memorizes training data and fails to generalize.

**GAN**
Two competing networks: generator and discriminator.

**VAE**
Model that generates data from compressed representation.

**Autoregressive Model**
Generates output sequentially.

**Diffusion Model**
Generates data by reversing noise process.

---

# [LLM](llm.md)

# Diffusion Models
