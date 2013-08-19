context("time series")

test_that("Bidirectional conversion TIME time series to zoo objects", {
  startDate <- '2001-01-01'
  numValues <- 1.1 * 1:5
  dts <- tts(numValues, as.Date(startDate), 'Daily')
  expect_equal(end(dts), as.POSIXct(startDate+5))
  
  # test daily, monthly, annual time series, then hourly, 6 minutes, minutes.
})

