#' Proteolytic digest a read_fastad fasta list
#'
#' @description
#' `digest()` Generates peptide sequences based on *enzyme* and *partial* inputs.
#' Only works with the "list" output of the `read_fasta()` function
#'
#' @param x an msfastar data object
#' @param ... parameters for `peptides()`
#' @param mc.cores number of parallel cores to use for processing
#'
#' @return a msfastar data object
#' @export
#'
#' @examples
#' library(msfastar)
#' proteins <- read_fasta("~/Local/fasta/ecoli_UniProt.fasta")
#'
#' proteins <- digest(proteins, enzyme = "[K]", partial = 2)
#'
digest <- function(
    x = NULL,
    regex = ".+?[KR]",
    partial = 2,
    lower_pep_len = 6,
    upper_pep_len = 30,
    remove_m = FALSE,
    mc.cores = 1
){

  cli::cli_progress_step(" .. digesting proteins")

  check_fasta(x)
  x <- parallel::mclapply(x, function(x) {
    x$peptides <- x$sequence |> protease(regex,
                                         partial,
                                         lower_pep_len,
                                         upper_pep_len,
                                         remove_m)
    return(x)
  }, mc.cores = mc.cores)

  return(msfastar(x))
}


#' Get all peptides from msfastar object as a vector
#'
#' @description
#' `get_peptides()` will return all peptides as string vector
#'
#' @param x an msfastar data object
#'
#' @return a vector
#' @export
#'
get_peptides <- function(
    x = NULL
){
  check_fasta(x)
  x <- lapply(x, function(x) { x$peptides }) |> unlist() |> unname()
  return(x)
}
