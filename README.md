# leo_web3_style_gauge


It is a tiny on-chain “style gauge” that selects one of three conceptual Web3 architectures, inspired by Aztec-style zk rollups, Zama-style FHE compute stacks, and soundness-first protocol labs. The decision is made from three numeric preference scores that you provide as inputs.


Repository structure

There are exactly two files in this repository.

1. app.leo – the Leo program with the main logic and a public transition
2. README.md – this document with installation, usage, examples and notes


Concept and relation to Web3, Aztec, Zama and soundness

The program treats three high level Web3 “styles” as options.

1. Aztec-style zk privacy rollup  
   Focused on encrypted balances and zero knowledge (zk) circuits over a base chain like Ethereum. Privacy and zk proofs are central, performance is tuned around private state and rollup proofs.

2. Zama-style FHE compute stack  
   Focused on fully homomorphic encryption (FHE) and encrypted compute pipelines around Web3 data. Privacy is achieved by never decrypting data during computation, but FHE is heavier than classic zk-only designs.

3. Soundness-first protocol lab  
   Focused on clear specifications, formal proofs, and soundness above everything else. Privacy can be present or not, but correctness and verifiability drive most choices.

The Leo script does not claim to model any real project from Aztec, Zama, or specific soundness labs. Instead it uses the idea of these projects as conceptual categories and lets you express which combination of privacy, FHE and soundness you care about most. The result is a single small integer value that can be published and verified on-chain in the Aleo ecosystem.


Program overview

Program name on-chain:

- web3_style_gauge.aleo

Core function:

- choose_style(privacy: u8, fhe: u8, soundness: u8) -> u8

Public transition:

- choose_style_public(privacy: u8, fhe: u8, soundness: u8) -> u8

Input parameters (all unsigned 8-bit integers, usually in the range 0 to 10):

- privacy  
  How important strong privacy is for your project, where 0 means “not important at all” and 10 means “absolutely critical”.

- fhe  
  How important fully homomorphic encryption is, where 0 means “we do not need FHE at all” and 10 means “FHE is a central feature”.

- soundness  
  How important strong soundness and formal reasoning are, where 0 means “we accept looser guarantees” and 10 means “we want formal theorems and strict proofs”.

Output value (single unsigned 8-bit integer):

- 0  
  The gauge recommends an Aztec-style zk privacy rollup.

- 1  
  The gauge recommends a Zama-style FHE compute stack.

- 2  
  The gauge recommends a soundness-first protocol lab design.


Scoring logic in words

The script converts each input into a slightly higher precision integer type and derives three scores.

- Aztec-style score  
  Strong weight on privacy, secondary weight on soundness. This matches the idea of a zk rollup like Aztec where privacy is the headline feature but soundness and correctness are still important.

- Zama-style score  
  Strong weight on both privacy and FHE. This reflects that an FHE heavy stack tries to keep data encrypted during compute and often pairs that with a privacy narrative.

- Soundness-first score  
  Strongest weight on soundness, plus a smaller weight on privacy. This fits a research style protocol that prioritizes formal models, proofs and verifiable semantics.

The script compares the three scores and returns the index of the style with the highest score. Ties are broken by the order of evaluation, which is Aztec first, then Zama, then soundness.


Installation

Prerequisites:

- Installed Leo toolchain from the official Aleo and Leo tooling sources
- A working Rust toolchain if required by your version of Leo
- A terminal environment with standard build tools

Basic installation steps:

1. Install the Leo CLI according to the instructions from the official Leo documentation for your operating system.

2. Create a new Leo project directory, or use an existing project where you want to integrate this style gauge.

3. Copy the file app.leo from this repository into the src directory of your Leo project or into a new project where app.leo is the only source file.

4. Ensure that your project configuration treats app.leo as the main program file. In a new Leo project, this can be done by replacing the generated main file with app.leo or by adjusting the paths in the configuration file so that web3_style_gauge.aleo is the active program.


Compilation and deployment

Once Leo is installed and app.leo is placed in your project:

1. Compile the Leo program using the Leo build command provided by your tooling. This will verify that app.leo is valid and produce the necessary artifacts.

2. Optionally run your project’s test or run commands if your version of Leo supports local execution of the transition choose_style_public.

3. When ready, deploy the compiled program to the Aleo network or to whatever environment your Leo setup targets, using the recommended deployment process from the Leo and Aleo documentation.


How to use choose_style_public

The public transition choose_style_public takes three integer arguments and produces a public output.

Inputs:

- privacy: u8  
- fhe: u8  
- soundness: u8  

Output:

- A single u8 that encodes the selected style.

A typical use pattern would be:

1. Decide on the three preference scores for a given project or configuration.

2. Call the choose_style_public transition with those scores either locally or on-chain, depending on your environment.

3. Read the output value and interpret it according to the mapping.

Interpretation of the output:

- 0 means: treat this project as closer to an Aztec-style zk privacy rollup.
- 1 means: treat this project as closer to a Zama-style FHE compute stack.
- 2 means: treat this project as closer to a soundness-first protocol lab.


Example scenarios (conceptual, not shell commands)

Scenario 1: Max privacy, high soundness, low FHE

- privacy = 10  
- fhe = 2  
- soundness = 8  

The chosen style is likely:

- 0, indicating an Aztec-style zk privacy rollup fits best.

Scenario 2: Max privacy, max FHE, medium soundness

- privacy = 9  
- fhe = 9  
- soundness = 6  

The chosen style is likely:

- 1, indicating a Zama-style FHE compute stack fits best.

Scenario 3: Medium privacy, low FHE, very high soundness

- privacy = 5  
- fhe = 1  
- soundness = 10  

The chosen style is likely:

- 2, indicating a soundness-first protocol lab design fits best.


Expected result and Web3 usage

When integrated into a broader Web3 application:

- The style gauge can provide a small on-chain signal about how a deployment or configuration should be classified.
- Other smart contracts or off-chain components can read the style index and adjust parameters, feature flags or documentation links accordingly.
- For example, a project flagged as Aztec-style could default to privacy-preserving paths and zk proof tooling. A Zama-style project could lean towards FHE backends. A soundness-first project could surface references to formal specs and proof archives.

Because the output is a simple integer, any Aztec-like, Zama-like or soundness-first component can interpret it without depending on heavy data structures.


Notes and limitations

- The script is deliberately simple and uses straightforward integer arithmetic. It is intended for experimentation, education and toy examples, not for production decision making.
- The style mapping is highly opinionated and informal. Real projects in the Aztec or Zama ecosystems, or in soundness-focused labs, may not fit cleanly into these three buckets.
- You are encouraged to fork the repository and adapt:
  - the scoring weights
  - the number of styles
  - the interpretation of the output
- You can also extend the program with:
  - additional inputs such as UX speed, gas sensitivity, or regulatory constraints
  - more complex aggregation logic
  - per-style confidence scores as additional outputs

Even in its minimal form, leo_web3_style_gauge demonstrates how Leo can encode Web3 design heuristics into a verifiable program that connects conceptually to Aztec-style privacy rollups, Zama-style FHE stacks, and soundness-first protocol design.
::contentReference[oaicite:0]{index=0}
