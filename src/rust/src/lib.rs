use extendr_api::prelude::*;
use std::str;
use regex::Regex;

/// Return cleaned seqeuence
/// @param s
/// A character string of amino acids
/// @export
#[extendr]
fn sequence_prep(s: &str) -> String {
    let s = str::to_uppercase(s);
    let re = Regex::new(r"[^A-Z]").unwrap();
    let mut s = re.replace_all(&s, "").to_string();
    s.push_str("#");
    return s;
}

/// The rust implementat to digest()
/// @param sequence
/// A character string of amino acids
///
/// @param regex
/// A character string regular expression use to proteolytically digest
/// the sequence.
/// - `[KR]` ... trypsin
/// - `[KR](?!P)` ... trypsin not at P
/// - `[R](?!P)` ... arg-c
/// - `[K](?!P)` ... lys-c
/// - `[FYWL](?!P)` ... chymotrypsin
/// - `[BD]` ... asp-n
/// - `[D]` ... formic acid
/// - `[FL]` ... pepsin-a
///
/// @param partial
/// A numeric representing the number of incomplete enzymatic sites (mis-clevage).
///
/// @param lower_pep_len
/// The minimum peptide length allowed
///
/// @param upper_pep_len
/// The maximum peptide length allowed
///
/// @param remove_m
/// A boolean to indicate if the n-term M should be variably removed
///
/// @export
#[extendr]
fn protease(sequence: &str,
            regex: &str,
            partial: i8,
            lower_pep_len: i32,
            upper_pep_len: i32,
            remove_m: bool) -> Vec<String> {

    // partial needs to a 1 for correct loop
    let partial = partial + 1;

    // Trim whitespace from the input
    let regex = regex.trim();

    // Create regex from user input
    let peptide_regex = Regex::new(regex).expect("Invalid peptide regex");

    // pull out all the string values
    let peptides: Vec<_> = peptide_regex
        .find_iter(&sequence)
        .map(|rsm| rsm.as_str().to_string())
        .collect();

    let mut combined_peptides = Vec::new();

    // account for the partial cleavages
    for i in 0..peptides.len() {
        let mut combined = String::new();
        for j in 0..partial {
            if let Some(peptide) = peptides.get(i as usize + j as usize) {
                combined.push_str(peptide);
                combined_peptides.push(combined.clone());
                // account for M removal
                if remove_m == TRUE && i == 0 && combined.chars().nth(0).unwrap() == 'M'{
                  combined_peptides.push(combined[1..combined.len()].to_string());
                }
            }
        }
    }

    let filtered_peptides = combined_peptides
            .iter()
            .filter(|rsm| {
                let peptide = rsm.as_str();
                peptide.len() as i32 >= lower_pep_len && peptide.len() as i32 <= upper_pep_len
                })
            .map(|rsm| rsm.as_str().to_string())
            .collect();

    return filtered_peptides;
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod msfastar;
    fn sequence_prep;
    fn protease;
}
