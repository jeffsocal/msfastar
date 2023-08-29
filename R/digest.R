#' Proteolytic digest a read_fastad fasta list
#'
#' @description
#' `digest()` Generates peptide sequences based on *enzyme* and *partial* inputs.
#' Only works with the "list" output of the `read_fasta()` function
#'
#' @param x an rmsfasta data object
#' @param ... parameters for `peptides()`
#' @param mc.cores number of parallel cores to use for processing
#'
#' @return a rmsfasta data object
#' @export
#'
#' @examples
#' library(rmsfasta)
#' proteins <- read_fasta("~/Local/fasta/ecoli_UniProt.fasta")
#'
#' proteins <- digest(proteins, enzyme = "[K]", partial = 2)
#'
digest <- function(
    x = NULL,
    ...,
    mc.cores = 1
){
  check_fasta(x)
  x <- parallel::mclapply(x, function(x) {
    x$peptides <- peptides(x$sequence, ...)
    return(x)
  }, mc.cores = mc.cores)
  return(rmsfasta(x))
}


#' Get all peptides from rmsfasta object as a vector
#'
#' @description
#' `get_peptides()` will return all peptides as string vector
#'
#' @param x an rmsfasta data object
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
