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
    ...,
    n = 5
) {

  check_fasta(x)
  n.size <- length(x)
  x.size <- as.numeric(utils::object.size(x))

  cli::cli_h2(cli::style_bold("{.emph R MS FASTA data object}"))
  println("memory", glue::glue("{prettyunits::pretty_bytes(x.size)}"))

  orgs <- lapply(x, function(x){ return(x$organism) }) |>
    unlist(use.names = FALSE) |>
    table() |>
    as.data.frame()

  orgs <- orgs[order(-orgs$Freq),]
  orgs$Freq <- orgs$Freq / n.size * 100
  orgs$Var1 <- orgs$Var1 |> as.character()

  if(nrow(orgs) > 0) {
    println("organisms", nrow(orgs))
    for(i in 1:min(n, nrow(orgs))){
      println(glue::glue("      {signif(orgs[i,2], 3)}%"), orgs$Var1[i])
    }
    o.perc <- orgs[min(n, nrow(orgs)):nrow(orgs),2] |> sum()
    println(glue::glue("      {signif(o.perc, 3)}%"), '...other')
  }

  println("sequences", n.size)
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
