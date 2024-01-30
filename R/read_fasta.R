#' Read the contents of a fasta file
#'
#' @description
#' `read_fasta()` reads in a fasta file and parses the meta data and protein
#' sequence based on the `patterns` regex definition.
#'
#' @param path
#' A character string of the path to the fasta formatted file
#'
#' @param patterns
#' A list, if not provided the default from `regex()` will be used.
#' *Note*: the first element in the regex list will define the list reference name, such
#' that with the list output, each protein can be accessed with that designation.
#' *Note*: if the patterns list is missing an explicit "sequence" element, no sequence will
#' be returned. This might be beneficial if only a few meta elements are sought.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(msfastar)
#' proteins <- system.file("extdata", "albu_human.fasta", package = "msfastar") |> read_fasta()
#'
#' # using a custom supplied regex list
#' proteins <- read_fasta(path = "~/Local/fasta/ecoli_UniProt.fasta",
#'                   pattern = list(
#'                       "accession" = "sp\\|[A-Z]",
#'                       "gene_name" = "(?<=GN\\=).*?(?=\\s..\\=)"
#'                   ))
#' }
#'
read_fasta <- function(
    path = NULL,
    patterns = NULL
){

  cli::cli_div(theme = list(span.emph = list(color = "#ff4500")))
  if(is.null(path)) {cli::cli_abort(c("x" = "path is empty"))}
  if(!grepl("\\.fasta", path)) {
    file_ext <- stringr::str_extract(path, "\\..+$")
    cli::cli_abort(c("x" = "expected a {.emph .fasta} file, got {.emph {file_ext}}"))
  }

  if(is.null(patterns)) { patterns <- regex() }
  if(mode(patterns) != 'list') {cli::cli_abort(c("x" = "patterns is `{mode(patterns)}`, should be a list"))}

  cli::cli_progress_step("Parsing FASTA file {basename(path)}")

  tryCatch({

    l_fasta <- readr::read_file(path)
    l_fasta <- gsub("->", "-", l_fasta)

    # read in fasta file
    l_fasta <- unlist(base::strsplit(l_fasta, ">"))
    l_fasta <- l_fasta[-1] # first in list is blank

    names(l_fasta) <- parallel::mclapply(l_fasta, extract, patterns[1]) |> unlist()
    l_fasta <- parallel::mclapply(l_fasta, extract, patterns)

  }, error = function(err) {
    err = as.character(as.vector(err))
    cli::cli_process_failed()
    cli::cli_abort(err)
  })

  return(msfastar(l_fasta))
}
