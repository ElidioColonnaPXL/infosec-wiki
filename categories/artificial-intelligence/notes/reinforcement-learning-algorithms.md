Fundamentals of AI
# Reinforcement Learning – Core Concepts

Reinforcement Learning (RL) is a learning paradigm where an **agent learns by interacting with an environment**.
Learning occurs through **trial and error**, guided by **rewards and penalties**, rather than labeled data.

Main characteristics:

- Sequential decision making

- Feedback-driven learning

- Focus on long-term outcomes

- No explicit correct answers


---

## 1. Types of Reinforcement Learning

|Type|Idea|Analogy|
|---|---|---|
|Model-Based RL|Learn a model of environment|Navigating with a map|
|Model-Free RL|Learn directly from experience|Navigating by trial and error|

---

## 2. How It Works (Intuition)

Like training a dog:

1. Action is performed

2. Environment responds

3. Reward or penalty is given

4. Behavior adapts over time


Goal: learn a **policy** that maximizes cumulative reward.

---

## 3. Core Concepts – Overview Table

|Concept|Short Explanation|
|---|---|
|Agent|Decision maker and learner|
|Environment|External system the agent interacts with|
|State|Snapshot of current situation|
|Action|Decision taken by agent|
|Reward|Feedback signal from environment|
|Policy|Strategy mapping states → actions|
|Value Function|Estimate of long-term return|
|Discount Factor|Importance of future rewards|
|Episodic Task|Interaction with clear end|
|Continuous Task|Interaction without end|

---

## 4. Detailed Concept Notes

### Agent

- Entity that learns and decides

- Observes state

- Chooses actions

- Improves behavior over time


Examples: robot, game player, self-driving system.

---

### Environment

- Everything outside the agent

- Responds to actions

- Produces new states and rewards


---

### State

- Current description of situation

- Contains relevant information

- Basis for decision making


---

### Action

- Move selected by agent

- Changes environment

- Leads to new state


---

### Reward

- Scalar feedback signal

- Positive → encourage behavior

- Negative → discourage behavior

- Objective: maximize total reward


---

### Policy

|Type|Behavior|
|---|---|
|Deterministic|Same action per state|
|Stochastic|Probabilistic choice|

Defines the agent strategy.

---

### Value Function

|Function|Meaning|
|---|---|
|State-value|Value of being in state|
|Action-value|Value of taking action|

Estimates future cumulative rewards.

---

### Discount Factor (γ)

|Value|Effect|
|---|---|
|γ = 0|Only immediate rewards|
|γ → 1|Long-term focused|

Controls short vs long horizon.

---

### Task Types

|Type|Description|
|---|---|
|Episodic|Has terminal state|
|Continuous|Runs indefinitely|

---

## 5. Learning Cycle

1. Observe state

2. Choose action

3. Receive reward

4. Update policy

5. Repeat


---

## 6. Where RL Is Used

- Game playing

- Robotics control

- Autonomous driving

- Resource management

- Recommendation systems


---

## 7. Key Differences from Other ML

- No labeled data

- Delayed feedback

- Sequential decisions

- Exploration vs exploitation trade-off

# [Q-Learning](q-learning.md)
# [SARSA](sarsa.md)
