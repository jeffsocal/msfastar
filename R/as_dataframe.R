#' Helper function for converting a msfastar object to a table
#'
#' @param x
#' An rmfasta data object
#'
#' @param row.names
#' Dead-end generic/method for consistency
#'
#' @param optional
#' Dead-end generic/method for consistency
#'
#' @param .drop
#' Call out columns to drop from the data.frame
#'
#' @param ...
#' Unused generic/method for consistency
#'
#' @exportS3Method
#'
as.data.frame.msfastar <- function(
    x,
    row.names = TRUE,
    optional = NULL,
    .drop = NULL,
    ...
) {

  if(!is.null(.drop)){
    .drop <- rlang::arg_match(.drop, names(x[[1]]), multiple = TRUE)
    .drop <- setdiff(names(x[[1]]), .drop)
  }

  check_fasta(x)
  x |>
    lapply(make_table, .drop) |>
    dplyr::bind_rows()
}

#' Helper function for converting a msfastar object to a table
#'
#' @param x
#' An rmfasta data object
#'
#' @export
#'
as_database <- function(
    x
) {
  check_fasta(x)
  protein_db <- x |>
    lapply(make_table, intersect(c('peptides','sequence'), names(x[[1]]))) |>
    dplyr::bind_rows()

  peptide_db <- x |>
    lapply(make_peptide_table) |>
    dplyr::bind_rows()

  return(list(proteins = protein_db, peptides = peptide_db))
}

#' Helper function for converting a msfastar object to a table
#'
#' @param x
#' An rmfasta data object
#'
#' @param .drop
#' Call out columns to drop from the data.frame
#'
make_table <- function(
    x,
    .drop = NULL
){

  if(!is.null(.drop)){
    w_drop <- which(names(x) %in% .drop)
    if(length(w_drop) > 0) { x <- x[-w_drop] }
  }

  w_pep <- which(names(x) == 'peptides')
  if(length(w_pep) > 0){
    v_pep <- x[w_pep] |> unlist() |> unname()
    tbl <- x[-w_pep] |> as.data.frame()
    tbl <- tbl[rep(1,length(v_pep)),]
    tbl$peptide <- v_pep
    rownames(tbl) <- NULL
    return(tbl)
  }

  x |> as.data.frame()
}

#' Helper function for converting a msfastar object to a table
#'
#' @param x
#' An rmfasta data object
#'
#' @param .drop
#' Call out columns to drop from the data.frame
#'
make_peptide_table <- function(
    x,
    .drop = NULL
){
  w_acc <- which(names(x) == 'accession')
  w_pep <- which(names(x) == 'peptides')

  v_acc <- x[w_acc] |> unlist() |> as.character()
  v_pep <- x[w_pep] |> unlist() |> as.character()

  data.frame(
    accession = rep(v_acc, length(v_pep)),
    peptide = v_pep
  )
}
