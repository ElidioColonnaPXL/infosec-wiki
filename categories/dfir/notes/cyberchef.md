# CyberChef

CyberChef is a browser-based workspace for decoding, transforming, and inspecting data. Operations are assembled into a recipe, so an analyst can repeat the same sequence and record exactly how an input was handled.

## Common uses

- Decode Base64, hexadecimal, URL-encoded, and escaped text.
- Extract strings, indicators, domains, and regular-expression matches.
- Decompress or unpack common data formats before deeper inspection.
- Calculate hashes and compare byte, text, and character representations.
- Test simple XOR, rotation, and substitution hypotheses on a copy of the data.

## Evidence-safe workflow

1. Preserve the original item and its hash.
2. Work on a copy, beginning with the smallest plausible transformation.
3. Inspect each recipe step instead of applying a long, unexplained chain.
4. Export the recipe or record its operations with the investigation notes.
5. Validate important results with a second tool or an independent method.

CyberChef is convenient for triage, but transformations can change evidence. Keep provenance, timestamps, hashes, and interpretation separate from the original input.

## Reference

- [CyberChef](https://gchq.github.io/CyberChef/)
