% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reorder.R
\name{reorder}
\alias{reorder}
\title{Create a reordered sequence database}
\usage{
reorder(data, method = c("reverse", "random"), tag = "DECOY", mc.cores = 1)
}
\arguments{
\item{data}{the data}

\item{method}{the method}

\item{tag}{the tag}

\item{mc.cores}{number of cores}
}
\description{
\code{reorder()} is used to reverse or shuffle a protein sequence for target-decoy use.
}
