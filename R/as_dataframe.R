#' Helper function for converting a RMSFasta object to a table
#'
#' @param x rmfasta data object
#' @param ... unused legacy
#'
#' @return a data.frame
#'
#' @exportS3Method
#'
as.data.frame.rmsfasta <- function(
    x,
    .drop = NULL,
    ...
) {

  if(!is.null(.drop)){
    .drop <- rlang::arg_match(.drop, names(x[[1]]), multiple = TRUE)
  }

  check_fasta(x)
  x |>
    lapply(make_table, .drop) |>
    dplyr::bind_rows()
}

#' Helper function for converting a RMSFasta object to a table
#'
#' @param x rmfasta data object
#'
#' @return a data.frame
#'
make_table <- function(x, .drop = NULL){

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
