// app.leo
// Leo program that picks a Web3 architecture style
// based on three simple preference scores.
//
// Styles:
//   0u8 => Aztec-style zk privacy rollup
//   1u8 => Zama-style FHE compute stack
//   2u8 => Soundness-first protocol lab
const MAX_PREF: u8 = 10u8;
program web3_style_gauge.aleo;
const STYLE_AZTEC: u8 = 0u8;
const STYLE_ZAMA: u8 = 1u8;
const STYLE_SOUND: u8 = 2u8;

// Returns a style index:
//   0u8 -> Aztec-style zk privacy rollup
//   1u8 -> Zama-style FHE compute stack
//   2u8 -> Soundness-first protocol lab

// Expects all inputs in the inclusive range [0, MAX_PREF].
function choose_style(
    privacy: u8,    // how important privacy is  (0–10)
    fhe: u8,        // how important FHE is      (0–10)
    soundness: u8   // how important soundness is (0–10)
) -> u8 {
    // Convert to u16 for safer arithmetic.
    let p: u16 = privacy as u16;
    let f: u16 = fhe as u16;
    let s: u16 = soundness as u16;
const W_PRIV_AZTEC: u16 = 3u16;
const W_SND_AZTEC: u16 = 2u16;

const W_PRIV_ZAMA: u16 = 3u16;
const W_FHE_ZAMA: u16 = 3u16;

const W_SND_SOUND: u16 = 4u16;
const W_PRIV_SOUND: u16 = 1u16;

    // Aztec-style: strong privacy, plus soundness.
  let aztec_score: u16 = p * W_PRIV_AZTEC + s * W_SND_AZTEC;

    // Zama-style: strong privacy plus FHE-heavy compute.
    let zama_score: u16 = p * W_PRIV_ZAMA + f * W_FHE_ZAMA;

    // Soundness-first: maximum weight on soundness, some privacy.
   let sound_score: u16 = s * W_SND_SOUND + p * W_PRIV_SOUND;

    // Note: in case of equal scores, the earlier style in this order wins:
    // Aztec (0) > Zama (1) > Soundness (2).

    // Track the best score and index.
        let mut best_idx: u8 = STYLE_AZTEC;
    let mut best_score: u16 = aztec_score;

    if zama_score > best_score {
        best_idx = STYLE_ZAMA;
        best_score = zama_score;
    };

    if sound_score > best_score {
        best_idx = STYLE_SOUND;
        best_score = sound_score;
    };

    best_idx
}
    // Basic input validation
    assert(privacy <= MAX_PREF);
    assert(fhe <= MAX_PREF);
    assert(soundness <= MAX_PREF);

/// Public wrapper so the chosen style can be verified on-chain.
transition choose_style_public(
    privacy: u8,
    fhe: u8,
    soundness: u8
) -> u8 {
    // Public wrapper transition so that the chosen style can be verified on-chain.
    let style: u8 = choose_style(privacy, fhe, soundness);
    style
}
