#' FASTA data object
#'
#' @param obj FASTA data list
#'
#' @return FASTA data object
#'
msfastar <- function(
    obj = NULL
) {
  class(obj) <- "msfastar"
  return(obj)
}

#' Check the integrity of a msfastar data object
#'
#' @description
#' `check_fasta()` is a helper function that checks the structure and contents of
#' a msfastar data object
#'
#' @param x
#' An rmfasta data object
#'
#' @return silent on success, an abort message on fail
#'
check_fasta <- function(
    x = NULL
){

  # fail if x is NULL
  if(is.null(x)) {
    cli::cli_div(theme = list(span.emph = list(color = "#ff4500")))
    cli::cli_abort(c("x" = "Input cannot be {.emph NULL}"))
  }
  if(mode(x) != "list") {
    cli::cli_abort(c("x" = "Input is {.emph mode(protein)}}, should be an {.emph list}"))
  }
  if(!methods::is(x, 'msfastar')) {
    cli::cli_div(theme = list(span.emph = list(color = "#ff4500")))
    cli::cli_abort(c("x" = "Input must be of type {.emph msfastar}"))
  }

}
