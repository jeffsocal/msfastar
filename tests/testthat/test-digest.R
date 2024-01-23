test_that("protease digestion", {

  expect_error(
    suppressMessages( digest() )
  )

  suppressMessages(
    psdb <- "../../inst/extdata/albu_human.fasta" |>
      read_fasta()
  )

  expect_equal(
    suppressMessages(
      psdb |>
        digest(
          regex = ".+?[KR]",
          partial = 2,
          lower_pep_len = 6,
          upper_pep_len = 30
        ) |>
        lapply(function(x){x$peptides |> length()}) |>
        unlist() |>
        sum()
    ),
    383
  )

  expect_equal(
    suppressMessages(
      psdb |>
        digest(
          regex = ".+?[HW]",
          partial = 2,
          lower_pep_len = 6,
          upper_pep_len = 30
        ) |>
        lapply(function(x){x$peptides |> length()}) |>
        unlist() |>
        sum()
    ),
    32
  )


})
