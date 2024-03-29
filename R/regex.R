#' Get/Set the FASTA meta data regex
#'
#' @description
#' `regex()` gets and sets the current regex patters to assist the `read_fasta()` function.
#' This simply provides the structure needed to read_fasta the fasta file, a custom list
#' can also be supplied. To set elements in the `regex()` function, simply provide a
#' list with complementary names to over-write the current list.
#'
#' @param params
#' A list of the meta data to be extracted from the fasta file
#'
#' Example:
#' ```
#' list(
#'   "accession" = "(?<=|)[A-Z0-9]{5,12}",
#'   "protein_name" = "(?<=|)[A-Z0-9\\_]{8,}(?=\\s)",
#'   "gene_name" = "(?<=GN\\=).*?(?=\\s..\\=)",
#'   "organism" = "(?<=OS\\=).*?(?=\\s..\\=)",
#'   "description" = "(?<=\\s).*?(?=\\s..\\=)",
#'   "sequence" = "[A-Z]"
#' )
#' ```
#'
#' @export
#'
#' @examples
#' library(msfastar)
#' regex()
#'
#' regex(list("accession" = "sp\\|[A-Z]"))
#'
regex <- function(
    params = NULL
){
  out <- list(
    "accession" = "(?<=|)[A-Z0-9]{5,12}",
    "protein_name" = "(?<=|)[A-Z0-9\\_]{8,}(?=\\s)",
    "gene_name" = "(?<=GN\\=).*?(?=\\s..\\=)",
    "organism" = "(?<=OS\\=).*?(?=\\s..\\=)",
    "description" = "(?<=\\s).*?(?=\\s..\\=)",
    "sequence" = "[A-Z]"
  )
  if(!is.null(params)) {
    if(mode(params) != 'list') {cli::cli_abort(c("x" = "params is `{mode(params)}`, should be a list"))}

    for( i in length(params)){
      out[[names(params[i])]] <- as.character(params[i])
    }
  }
  return(out)
}
