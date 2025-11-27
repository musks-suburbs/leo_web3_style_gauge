// web3_style_gauge.aleo
// Tiny style selector for Web3 architectures (Aztec / Zama / Soundness-first).
// This file is intentionally minimal: no randomness, only pure scoring logic.
// app.leo
// Leo program that picks a Web3 architecture style
// based on three simple preference scores.
//
// Styles:
//   0u8 => Aztec-style zk privacy rollup
//   1u8 => Zama-style FHE compute stack
//   2u8 => Soundness-first protocol lab

program web3_style_gauge.aleo;

function choose_style(
    privacy: u8,    // how important privacy is  (0–10)
    fhe: u8,        // how important FHE is      (0–10)
    soundness: u8   // how important soundness is (0–10)
) -> u8 {
    // Convert to u16 for safer arithmetic.
    let p: u16 = privacy as u16;
    let f: u16 = fhe as u16;
    let s: u16 = soundness as u16;

    // Aztec-style: strong privacy, plus soundness.
    let aztec_score: u16 = p * 3u16 + s * 2u16;

    // Zama-style: strong privacy plus FHE-heavy compute.
    let zama_score: u16 = p * 3u16 + f * 3u16;

    // Soundness-first: maximum weight on soundness, some privacy.
    let sound_score: u16 = s * 4u16 + p;

    // Track the best score and index.
    let mut best_idx: u8 = 0u8;
    let mut best_score: u16 = aztec_score;

    if zama_score > best_score {
        best_idx = 1u8;
        best_score = zama_score;
    };

    if sound_score > best_score {
        best_idx = 2u8;
        best_score = sound_score;
    };

    best_idx
}

transition choose_style_public(
    privacy: u8,
    fhe: u8,
    soundness: u8
) -> u8 {
    // Public wrapper transition so that the chosen style can be verified on-chain.
    let style: u8 = choose_style(privacy, fhe, soundness);
    style
}
