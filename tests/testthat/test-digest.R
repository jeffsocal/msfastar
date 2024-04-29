test_that("protease digestion", {

  expect_error(
    suppressMessages( digest() )
  )

  suppressMessages(
    psdb <- system.file("extdata", "albu_human.fasta", package = "msfastar") |>
      read_fasta()
  )

  expect_equal(
    suppressMessages(
      psdb |>
        digest(
          regex = ".+?[KR]",
          partial = 2,
          peptide_length = c(6, 30)
        ) |>
        lapply(function(x){x$peptides |> length()}) |>
        unlist() |>
        sum()
    ),
    392
  )

  expect_equal(
    suppressMessages(
      psdb |>
        digest(
          regex = ".+?[HW]",
          partial = 2,
          peptide_length = c(6, 30)
        ) |>
        lapply(function(x){x$peptides |> length()}) |>
        unlist() |>
        sum()
    ),
    32
  )


})
