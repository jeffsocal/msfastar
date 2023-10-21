#' The main function for parsing a fasta file
#'
#' @description
#' `save_fasta()` save the file
#'
#' @param fasta_object a fasta db object
#'
#' @return a success TRUE|FAIL
#' @export
#'
save_fasta <- function(
    fasta = NULL,
    path = 'test.fasta'
){

  cli::cli_progress_step("Saving FASTA file {basename(path)}")

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
