program web3_style_gauge_v3.aleo;

// ------------------------
// Core scoring function
// ------------------------

// Compute the four style scores from raw sliders.
function compute_scores(
    privacy: u8,
    fhe: u8,
    soundness: u8,
    ux_speed: u8,
) -> (u16, u16, u16, u16) {
    let privacy16: u16 = privacy as u16;
    let fhe16: u16 = fhe as u16;
    let soundness16: u16 = soundness as u16;
    let ux16: u16 = ux_speed as u16;

    let aztec_score: u16 =
        privacy16 * W_PRIVACY_AZTEC +
        soundness16 * W_SOUNDNESS_AZTEC +
        ux16 * W_UX_AZTEC;

    let zama_score: u16 =
        privacy16 * W_PRIVACY_ZAMA +
        fhe16 * W_FHE_ZAMA +
        soundness16 * W_SOUNDNESS_ZAMA;

    let soundness_score: u16 =
        soundness16 * W_SOUNDNESS_SND +
        privacy16 * W_PRIVACY_SND;

    let ux_score: u16 =
        ux16 * W_UX_UX +
        privacy16 * W_PRIVACY_UX +
        soundness16 * W_SOUNDNESS_UX;

    return (aztec_score, zama_score, soundness_score, ux_score);
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
