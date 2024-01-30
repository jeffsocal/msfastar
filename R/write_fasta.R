#' Write contents to a fasta file
#'
#' @description
#' `write_fasta()` is the main function for writing a msfastar data object to a
#' fasta file. This function is currently in BETA, it will just print the contents
#' to stdout.
#'
#' @param fasta
#' A fasta db object
#'
#' @param path
#' A character string of the path to the fasta formatted file
#'
#' @export
#'
write_fasta <- function(
    fasta = NULL,
    path = NULL
){

  if(is.null(path)) {cli::cli_abort(c("x" = "path is empty"))}
  if(is.null(fasta)) {cli::cli_abort(c("x" = "fasta is empty"))}

  check_fasta(fasta)

  cli::cli_progress_step("Writing FASTA file {basename(path)}")

  # file_conn <- file(path)

  pro <- names(fasta)

  for(p in pro){

    seq <- strsplit(fasta[[p]]$sequence, "(?<=.{60})", perl = TRUE)[[1]] |>
      paste(collapse = "\n")
    des <- paste(
      'sp|', fasta[[p]]$accession, '|', fasta[[p]]$protein_name, ' ', fasta[[p]]$description,
      ' OS=', fasta[[p]]$organism, ' GN=', fasta[[p]]$gene_name, sep = '')

    out <- paste(seq, "\n", des, "\n")

    print(out)

    # file_conn |> writeLines(out)
  }

  # file_conn |> close()
}
