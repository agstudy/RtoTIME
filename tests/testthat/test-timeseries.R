context("time series")

testCsHelperType <- 'CSIRO.TIME2R.Tests.TestThat'

test_that("Bidirectional conversion TIME time series to zoo objects", {
  testTs <- function(tts, expectedValues, expectedTimeStep, expectedStart) { 
    clrCallStatic(testCsHelperType, 'TestTimeSeries', tts, expectedValues, expectedTimeStep, expectedStart)
  }
  startDate <- as.POSIXct('2001-01-01', tz='UTC')
  numValues <- 1.1 * 1:5
  tSteps <- c('Annual','Monthly','Daily','Hourly','00:06:00')
  for (tStep in tSteps) {
    expect_true(testTs( tts(numValues,startDate, tStep), numValues, tStep, startDate))
  }
})

