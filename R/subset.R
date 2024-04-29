#' Create a data subset
#'
#' @description
#' `subset()` is the main function for sub-setting spectra data from a ms2spectra
#' data-object based on a regular expression and targeted annotation. This function
#' will return a smaller ms2spectra data-object.
#'
#' @param x
#' An ms2spectra data object
#'
#' @param ...
#' A three part expression (eg. x == a)
#'
#' @param .verbose
#' A boolean to print messages
#'
#' @exportS3Method
#'
subset.msfastar <- function(
    x = NULL,
    ...,
    .verbose = TRUE
){

  # visible bindings
  sample_id <- NULL

  data <- x
  check_fasta(data)
  str_quo <- tidyproteomics:::tidyproteomics_quo(...)
  if(is.null(str_quo)) { return(data) }

  variable <- str_quo[['variable']]
  operator <- str_quo[['operator']]
  value <- str_quo[['value']]
  inverse <- str_quo[['inverse']]
  inverse_str <- ''
  if(inverse == TRUE) { inverse_str <- '!' }

  if(!variable %in% names(data[[1]])){
    cli::cli_div(theme = list(span.emph = list(color = "#ff4500")))
    cli::cli_abort("data does not contain the field {.emph {variable}}. Use one of {.emph {names(data[[1]])}}")
  }

  if(.verbose == TRUE) {
    cli::cli_text("")
    cli::cli_div(theme = list(span.emph = list(color = "#ff4500"), span.info = list(color = "blue")))
    cli::cli_progress_step("Subsetting data: {.emph {inverse_str}{variable}} {.info {operator}} {.emph {value}}")
  }

  operator <- rlang::arg_match(operator, c("==","!=","%like%"))
  if(is.null(data) || is.null(variable) || is.null(value)) {return(data)}



  w <- c()
  if(operator == "=="){ w <- which(data[[variable]] == value) }
  else if(operator == "!="){ w <- which(data[[variable]] != value) }
  else if(operator == '%like%'){w <- which(data |> lapply(function(x){grepl(value, x[variable])}) == TRUE)}


  if(length(w) > 0) {
    if(inverse == TRUE){ data <- data[-w] }
    else{ data <- data[w] }
  }

  cli::cli_progress_done()
  return(msfastar(data))
}
