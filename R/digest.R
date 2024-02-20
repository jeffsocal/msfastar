#' Proteolytic digest a fasta data object
#'
#' @description
#' `digest()` Generates peptide sequences based on *enzyme* and *partial* inputs.
#' Only works with the "list" output of the `read_fasta()` function
#'
#' @param x
#' An rmfasta data object
#'
#' @param regex
#' The regular expression used to specify which amino acids to cleave at.
#'  - `.*?[KR]` ... trypsin
#'  - `.*?[KR](?!P)` ... trypsin not at P
#'  - `.*?[R](?!P)` ... arg-c
#'  - `.*?[K](?!P)` ... lys-c
#'  - `.*?[FYWL](?!P)` ... chymotrypsin
#'  - `.*?[BD]` ... asp-n
#'  - `.*?[D]` ... formic acid
#'  - `.*?[FL]` ... pepsin-a
#'
#' @param partial
#' The number of incomplete cleavage sites peptides can retain in the database
#'
#' @param peptide_length
#' As numeric vector representing the minimum and maximum sequence lengths.
#'
#' @param remove_m
#' A boolean to indicate if the n-term M should be variably removed
#'
#' @param mc.cores
#' The number of CPU cores to engage in protein digestion
#'
#' @export
#'
#' @examples
#' library(msfastar)
#' proteins <- system.file("extdata", "albu_human.fasta", package = "msfastar") |> read_fasta()
#'
#' proteins <- digest(proteins, regex = ".*?[K]", partial = 2)
#'
digest <- function(
    x = NULL,
    regex = ".*?[KR]",
    partial = 2,
    peptide_length = c(6, 30),
    remove_m = FALSE,
    mc.cores = 1
){

  cli::cli_progress_step(" .. digesting proteins")

  check_fasta(x)

  x <- parallel::mclapply(x, function(x) {
    x$peptides <- x$sequence |>
      protease(regex,
               partial,
               min(peptide_length),
               max(peptide_length),
               remove_m)
    return(x)
  }, mc.cores = mc.cores)

  return(msfastar(x))
}


#' Get all peptides from msfastar object as a vector
#'
#' @description
#' `get_peptides()` will return all peptides as single string vector
#'
#' @param x
#' An rmfasta data object
#'
#' @export
#'
get_peptides <- function(
    x = NULL
){
  check_fasta(x)
  x <- lapply(x, function(x) { x$peptides }) |> unlist() |> unname()
  return(x)
}
