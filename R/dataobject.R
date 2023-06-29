#' FASTA data object
#'
#' @param obj FASTA data list
#'
#' @return FASTA data object
#'
rmsfasta <- function(obj) {
  class(obj) <- "rmsfasta"
  return(obj)
}

#' Check the integrity of a rmsfasta data object
#'
#' @description
#' `check_fasta()` is a helper function that checks the structure and contents of
#' a rmsfasta data object
#'
#' @param data rmsfasta data object
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
  if(class(x) != 'rmsfasta') {
    cli::cli_div(theme = list(span.emph = list(color = "#ff4500")))
    cli::cli_abort(c("x" = "Input must be of type {.emph rmsfasta}"))
  }

}
