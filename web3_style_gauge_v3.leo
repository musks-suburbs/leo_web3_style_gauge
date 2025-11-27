program web3_style_gauge_v3.aleo;

// ------------------------
// Core scoring function
// ------------------------

function choose_style_extended(
    privacy: u8,
    fhe: u8,
    soundness: u8,
    ux_speed: u8,
) -> u8 {
    // Cast to a larger integer type to avoid easy overflow
    let privacy16: u16 = privacy as u16;
    let fhe16: u16 = fhe as u16;
    let soundness16: u16 = soundness as u16;
    let ux16: u16 = ux_speed as u16;
    let (aztec_score, zama_score, soundness_score, ux_score) =
        compute_scores(privacy, fhe, soundness, ux_speed);

    // Heuristic weights (tweak as you like):
    //
    // Aztec-style: strong privacy, good soundness, some UX.
    let aztec_score: u16 =
        privacy16 * 3u16 +
        soundness16 * 2u16 +
        ux16 * 1u16;

    // Zama-style: strong privacy + FHE, some soundness.
    let zama_score: u16 =
        privacy16 * 2u16 +
        fhe16 * 3u16 +
        soundness16 * 1u16;

    // Soundness-first: strongest weight on soundness, some privacy.
    let soundness_score: u16 =
        soundness16 * 4u16 +
        privacy16 * 1u16;

    // UX / DeFi-style: strongest on UX, some privacy, light soundness.
    let ux_score: u16 =
        ux16 * 4u16 +
        privacy16 * 1u16 +
        soundness16 * 1u16;

    // Pick the max score; ties are broken by the order of checks
    // (Aztec -> Zama -> Soundness -> UX).
    let mut best_index: u8 = 0u8;
    let mut best_score: u16 = aztec_score;

    if zama_score > best_score {
        best_score = zama_score;
        best_index = 1u8;
    }

    if soundness_score > best_score {
        best_score = soundness_score;
        best_index = 2u8;
    }

    if ux_score > best_score {
        best_score = ux_score;
        best_index = 3u8;
    }

    return best_index;
}

// ------------------------
// Public transitions
// ------------------------

// A simple public transition mirroring the original idea, but with ux_speed
// and the extended style set.
transition choose_style_public_v3(
    privacy: u8,
    fhe: u8,
    soundness: u8,
    ux_speed: u8,
) -> u8 {
    let style: u8 = choose_style_extended(privacy, fhe, soundness, ux_speed);
    return style;
}

// This one exposes all scores AND the chosen style index,
// useful for debugging or richer off-chain logic.
transition style_scores_public(
    privacy: u8,
    fhe: u8,
    soundness: u8,
    ux_speed: u8,
) -> (u16, u16, u16, u16, u8) {
    let privacy16: u16 = privacy as u16;
    let fhe16: u16 = fhe as u16;
    let soundness16: u16 = soundness as u16;
    let ux16: u16 = ux_speed as u16;

    let aztec_score: u16 =
        privacy16 * 3u16 +
        soundness16 * 2u16 +
        ux16 * 1u16;

    let zama_score: u16 =
        privacy16 * 2u16 +
        fhe16 * 3u16 +
        soundness16 * 1u16;

    let soundness_score: u16 =
        soundness16 * 4u16 +
        privacy16 * 1u16;

    let ux_score: u16 =
        ux16 * 4u16 +
        privacy16 * 1u16 +
        soundness16 * 1u16;

    let chosen: u8 =
        choose_style_extended(privacy, fhe, soundness, ux_speed);

    return (aztec_score, zama_score, soundness_score, ux_score, chosen);
}
