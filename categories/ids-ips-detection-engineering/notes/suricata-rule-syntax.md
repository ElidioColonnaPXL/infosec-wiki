# Suricata Rule Syntax

A Suricata rule combines an action and packet header with parenthesized options:

```text
action protocol source_ip source_port direction destination_ip destination_port (options)
```

```suricata
alert http $HOME_NET any -> $EXTERNAL_NET any (msg:"Example administrative path request"; flow:established,to_server; http.uri; content:"/admin"; nocase; sid:1000001; rev:1;)
```

## Header fields

- **Action** controls the result, such as `alert`, `pass`, `drop`, or `reject` where the deployment mode supports it.
- **Protocol** selects the parser or network protocol.
- **Addresses and ports** accept variables, individual values, lists, and negation.
- **Direction** uses `->` for one direction and `<>` for either direction.

## Options

Options are separated by semicolons. `msg` describes the detection, `flow` constrains session direction and state, sticky buffers such as `http.uri` select normalized application data, and `content` supplies a match. Every locally managed rule needs a unique `sid`; increase `rev` whenever its logic changes. Metadata such as `classtype` and references make alerts easier to triage.

Validate syntax before deployment, test against representative traffic, and tune for the intended network. Prefer the narrowest stable protocol buffer and context that express the behavior without binding the rule to a single captured sample.

## Reference

- [Suricata rule documentation](https://docs.suricata.io/en/latest/rules/intro.html)
