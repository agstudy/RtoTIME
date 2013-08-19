context("time series")

test_that("Bidirectional conversion TIME time series to zoo objects", {
  dts <- createTts(rnorm(1:6), as.Date('2001-01-01'), 'Daily')
})

