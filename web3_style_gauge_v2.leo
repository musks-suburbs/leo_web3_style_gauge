program web3_style_gauge_v2.aleo;

/// Public record of one gauge configuration + computed result.
record GaugePublic {
    owner: address,
    privacy: u8,
    soundness: u8,
    performance: u8,
    score: u8,   // 0–100 overall style score
    class: u8,   // 0=conservative, 1=balanced, 2=aggressive
}

/// Compute the overall style score from three 0–100 inputs.
function compute_score(privacy: u8, soundness: u8, performance: u8) -> u8 {
    // Work in u16 to avoid overflow, then cast back to u8.
    let p: u16 = privacy as u16;
    let s: u16 = soundness as u16;
    let t: u16 = performance as u16;

    let sum: u16 = p + s + t;
    let avg: u16 = sum / 3u16;

    return avg as u8;
}

/// Classify the style score into a tiny discrete category.
function classify_style(score: u8) -> u8 {
    // 0–33   -> 0 (conservative / low-risk)
    // 34–66  -> 1 (balanced)
    // 67–100 -> 2 (aggressive / perf-heavy)

    if score <= 33u8 {
        return 0u8;
    } else if score <= 66u8 {
        return 1u8;
    } else {
        return 2u8;
    }
}

/// Pure helper so you can just call this function from tooling/tests.
function compute_gauge(privacy: u8, soundness: u8, performance: u8) -> (u8, u8) {
    let score: u8 = compute_score(privacy, soundness, performance);
    let class: u8 = classify_style(score);
    return (score, class);
}

/// Transition that "sets" your gauge and emits a public record.
/// You could later index these records off-chain or in tooling.
transition set_gauge(privacy: u8, soundness: u8, performance: u8) -> GaugePublic {
    // In Aleo, the caller is the transaction sender.
        // self.caller -> address of the transaction sender.
    let owner: address = self.caller;


    let score: u8 = compute_score(privacy, soundness, performance);
    let class: u8 = classify_style(score);

    let gauge: GaugePublic = GaugePublic {
        owner,
        privacy,
        soundness,
        performance,
        score,
        class,
    };

    return gauge;
}
