# Recurrent Neural Networks

introduction to Deep Learning

`Recurrent Neural Networks` (`RNNs`) are a class of artificial neural networks specifically designed to handle sequential data, where the order of the data points matters.


### LSTMs and GRUs
To address the vanishing gradient problem, researchers have developed specialized RNN architectures, namely `Long-Short-Term Memory (LSTM)` and `Gated Recurrent Unit (GRU)` networks. These architectures introduce gating mechanisms that control the flow of information through the network, allowing them to better capture long-term dependencies.


`LSTMs` incorporate memory cells that can store information over extended periods. These cells are equipped with three gates:

- `Input gate:` Regulates the flow of new information into the memory cell.
- `Forget gate:` Controls how much of the existing information in the memory cell is retained or discarded.
- `Output gate:` Determines what information from the memory cell is output to the next time step.


 `GRUs` offer a simpler alternative to LSTMs, with only two gates:

- `Update gate:` Controls how much of the previous hidden state is retained.
- `Reset gate:` Determines how much of the previous hidden state is combined with the current input.

## Bidirectional RNNs

In addition to the standard RNNs that process sequences in a forward direction, there are also `bidirectional RNNs`. These networks process the sequence in both forward and backward directions simultaneously.
