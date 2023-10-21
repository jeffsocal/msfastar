#' Proteolytic digest a sequence
#'
#' @description
#' `peptides()` Generates peptide sequences based on `enzyme` and `partial` inputs.
#'
#' @param sequence as character string
#' @param partial a numeric representing the number of incomplete enzymatic sites (mis-clevage).
#' @param length as numeric vactor representing the minimum and maximum sequence lengths.
#' @param enzyme a character string regular expression use to proteolytically digest
#' the sequence.
#'  - `[KR]` ... trypsin
#'  - `[KR](?!P)` ... trypsin not at P
#'  - `[R](?!P)` ... arg-c
#'  - `[K](?!P)` ... lys-c
#'  - `[FYWL](?!P)` ... chymotrypsin
#'  - `[BD]` ... asp-n
#'  - `[D]` ... formic acid
#'  - `[FL]` ... pepsin-a
#'
#' @return a vector
#' @export
#'
#' @examples
#' library(rmsfasta)
#' sequence <- "SAMERSMALLKPSAMPLERSEQUENCE"
#' peptides(sequence)
#'
#' peptides(sequence, enzyme = "[L]", partial = 2, length = c(1,12))
#'
peptides <- function(
    sequence = NULL,
    enzyme = "[KR]",
    partial = 0:3,
    length = c(6,30),
    remove_nterm_m = TRUE
){

  if(mode(partial) != 'numeric') {cli::cli_abort(c("x" = "partial is `{mode(partial)}`, should be an numeric"))}
  partial <- as.integer(partial[1])
  if(mode(length) != 'numeric') {cli::cli_abort(c("x" = "length is `{mode(length)}`, should be an numeric"))}
  length <- as.integer(c(min(length), max(length)))

  if(mode(sequence) != 'character') {cli::cli_abort(c("x" = "sequence is `{mode(sequence)}`, should be a character string"))}
  if(mode(enzyme) != 'character') {cli::cli_abort(c("x" = "enzyme is `{mode(sequence)}`, should be a regex character string"))}
  if(grepl("[a-z]", sequence)) {
    cli::cli_warn(c("x" = "sequence contains lowercase characters -> replacing"))
    sequence <- sequence |> stringr::str_to_upper()
  }
  if(grepl("[^A-Z]", sequence)) {
    cli::cli_warn(c("x" = "sequence contains non alpha characters -> removing"))
    sequence <- sequence |> stringr::str_remove("[^A-Z]")
  }

  enzyme <- sub("\\]", "#]", enzyme)

  p <- list()
  nterm <- c()
  p[[1]] <- sub("\\#", "", stringr::str_extract_all(paste0(sequence,"#"), paste0("(.*?", enzyme, ")"))[[1]])
  if(remove_nterm_m == TRUE) nterm <- c(nterm, trimws(p[[1]][1], 'left', whitespace = 'M'))
  if(partial >= 1){
    p[[2]] <- paste0(p[[1]][-base::length(p[[1]])], p[[1]][-1])
    if(remove_nterm_m == TRUE) nterm <- c(nterm, trimws(p[[2]][1], 'left', whitespace = 'M'))
  }
  if(partial >= 2){
    p[[3]] <- paste0(p[[2]][-base::length(p[[2]])], p[[1]][-c(1,2)])
    if(remove_nterm_m == TRUE) nterm <- c(nterm, trimws(p[[3]][1], 'left', whitespace = 'M'))
  }

  p <- unique(c(unlist(p), nterm))
  p <- p[which(!is.na(p))]

  w <- unique(c(which(stringr::str_length(p) < length[1]),
                which(stringr::str_length(p) > length[2])))
  if(length(w) > 0) {p <- p[-w]}

  return(p)
}
