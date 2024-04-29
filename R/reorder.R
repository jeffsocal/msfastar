#' Create a reordered sequence database
#'
#' @description
#' `reorder()` is used to reverse or shuffle a protein sequence for target-decoy use.
#'
#' @param data the data
#'
#' @param method the method
#'
#' @param tag the tag
#'
#' @param mc.cores number of cores
#'
#' @export
#'
reorder <- function(
    data,
    method = c("reverse","random"),
    tag = "DECOY",
    mc.cores = 1
){

  check_fasta(data)
  method = rlang::arg_match(method)
  mc.cores = min(mc.cores, parallel::detectCores())

  cli::cli_progress_step(" .. reordering protein sequences")

  data <- data |> parallel::mclapply(function(x, p) {

    has_m <- x$sequence |> stringr::str_detect("^M")

    if(has_m == TRUE){ x$sequence <- x$sequence |> stringr::str_remove("^M") }
    x$sequence <- x$sequence |> stringr::str_split("") |> unlist() |> rev() |> paste(collapse = '')
    x$accession <- paste(x$accession, p, sep = "_")
    if(has_m == TRUE){ x$sequence <- paste0("M", x$sequence) }

    return(x)
  },
  tag,
  mc.cores = mc.cores)

  return(msfastar(data))
}
