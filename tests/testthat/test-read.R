test_that("read and parse a FASTA file", {

  expect_error(
    suppressMessages(
      "nopath/albu_human.fasta" |> read_fasta()
    )
  )

  expect_error(
    suppressMessages(
      "../../docs/404.html" |> read_fasta()
    )
  )

  suppressMessages(
    psdb <- system.file("extdata", "albu_human.fasta", package = "msfastar") |>
      read_fasta()
  )

  expect_equal(length(psdb), 3)
  expect_equal(length(psdb[[1]]), 6)

})
