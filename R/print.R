#' A helper function for the print definition of a msfastar object
#'
#' @param x
#' An rmfasta data object
#'
#' @param ...
#' Unused legacy
#'
#' @exportS3Method
#'
print.msfastar <- function(
    x,
    ...
) {

  check_fasta(x)
  x.size <- as.numeric(utils::object.size(x))

  cli::cli_h2(cli::style_bold("{.emph R MS FASTA data object}"))
  println("memory", glue::glue("{prettyunits::pretty_bytes(x.size)}"))

  orgs <- unique(unlist(lapply(x, function(x){ return(x$organism) })))
  if(length(orgs) > 0) {
    println("organisms", glue::glue("{paste0(orgs, collapse = ', ')}"))
  }

  println("sequences", glue::glue("{length(x)}"))
  leng <- unlist(lapply(x, function(x){ return(stringr::str_length(x$sequence)) }))
  if(length(leng) > 0) {
    println("", glue::glue("shortest:  {min(leng)} residues"))
    println("", glue::glue("longest:   {max(leng)} .."))
    println("", glue::glue("95%CI:     {paste(round(quantile(leng, c(0.025, 0.975))), collapse=' - ')} .."))
  }

  peps <- unlist(lapply(x, function(x){ return(x$peptides) }))
  if(length(leng) > 0) {
    println("peptides", glue::glue("total:     {length(peps)}"))
    println("", glue::glue("unique:    {length(unique(peps))}"))
  }

  println("")
  invisible(x)

}

#' Helper function for printing messages
#'
#' @param name string
#' @param message string
#' @param pad_length string
#'
#' @return console print line
#'
println <- function(name = '',
                    message = '',
                    pad_length = 15) {
  cat(stringr::str_pad(name, pad_length, 'right'), message, "\n")
}
