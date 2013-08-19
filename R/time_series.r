#' convert form a TIME time series to a zoo series
#'
#' @param x an object of class 'timets'
#' @param ... arguments passed to the zoo constructor
#' @return a zoo DAILY time series
#' @seealso /code{/link{timets}}
#' @export
#' @import zoo
as.zoo.timets <- function(x, ...) 
{
  startdate <- attr(x, "startdate")
  startdate <- as.Date(startdate)
  xdata = clrCallStatic(timeDataConvTypename, 'ToNumericVectorPtr', x)
  index <- startdate + 0:(length(xdata)-1)
	zoo(xdata, index, ...)
}


#' Retrieves a recorded 'TIME' time series from a simulation
#'
#' Retrieves a recorded 'TIME' time series from a simulation. R users are likely to prefer 
#'
#' @param simulation a object implementing the IPointTimeSeriesSimulation interface, for instance a ModelRunner object
#' @param varName name of the output variable recorded to a time series.
#' @return a clrobj object 
#' @export
#' @import rClr
getRecordedTts <- function(simulation, varName = 'runoff') {
  clrCall(simulation, 'GetRecorded', varName)
}

#' Flag a model output to be recorded at the next simulation execution
#'
#' Flag a model output to be recorded at the next simulation execution
#'
#' @param simulation a object implementing the IPointTimeSeriesSimulation interface, for instance a ModelRunner object
#' @param varName name(s) of the output variable(s) recorded to a time series.
#' @export
recordTimeSeries <- function(simulation, varName = 'runoff') {
  if(length(varName) == 1) {
    internalRecordTimeSeries(simulation, varName)
  } else {
    lapply(varName, function(vname) {internalRecordTimeSeries(simulation, vname)} )
  }
  invisible()
}

internalRecordTimeSeries <- function(simulation, varName) {
  clrCall(simulation, 'Record', varName)
}

#' Flag a model output to be recorded at the next simulation execution
#'
#' Flag a model output to be recorded at the next simulation execution
#'
#' @param simulation a object implementing the IPointTimeSeriesSimulation interface, for instance a ModelRunner object
#' @param varName name of the output variable recorded to a time series.
#' @param timeSeries a TIME time series object, or a zoo time series.
#' @return a clrobj object pointing to a TIME time series containing the output
#' @export
playTimeSeries <- function(simulation, varName, timeSeries) {
  if(is.zoo(timeSeries)) {
    timeSeries <- zooToDailyTts(timeSeries)
  }
  clrCall(simulation, 'Play', varName, timeSeries)
}

toArray <- function(obj) { clrCall(obj, 'ToArray') }

#' Create a 'TIME' time series 
#'
#' Create a 'TIME' time series 
#'
#' @param values the numeric vector of values in the time series
#' @param startDate an R Date object, start date
#' @param timeStep a case-sensitive string such as "Daily", "Monthly"
#' @return a 'TIME' time series
#' @export
createTts <- function(values, startDate, timestep) {
  clrCallStatic( timeSeriesHelperTypename, 'CreateTimeSeries', values, startDate, timestep )
}

#' Convert a 'zoo' series to a 'TIME' time series
#'
#' Convert a 'zoo' series to a 'TIME' time series
#'
#' @param zoots a zoo time series
#' @return a clrobj object of type TIME.DataTypes.TimeSeries
#' @export
zooToDailyTts <- function(zoots) {
  clrCallStatic( timeSeriesHelperTypename, 'CreateDailyTimeSeries', as.numeric(zoots), index(zoots)[1])
}

#' Convert a 'TIME' time series to a 'zoo' series
#'
#' Convert a 'TIME' time series to a 'zoo' series
#'
#' @param tts a clrobj object of type TIME.DataTypes.TimeSeries
#' @return a zoo time series
#' @export
ttsToZoo <- function(tts) {
  # A periodic time series with DateTimeKind unspecified, would end up with nonperiodic with POXISt times
  # Let's consider this is UTC. Debatable behavior, this is a messy situation either way
  startDate <- as.POSIXct(clrCallStatic( timeSeriesHelperTypename, 'GetIsoDateTimeStringStart', tts ), tz='UTC')
  tstepDays <- rttGetTimeStepDays(tts)
  len <- clrCall(tts, 'count')
  # Now that rClr returns POSIXct objects for System.DateTime
  zoo(toArray(tts), startDate+ (86400)*(0:(len*tstepDays-1)))
}

rttGetTimeStepDays <- function(tts) {
  days <- clrCallStatic( timeSeriesHelperTypename, 'GetRegularTimeStepLengthDays', tts )
  if( days < 0 ) { stop('Unsupported time step - only regular time steps supported for conversion to R series') }
  days
}

#' OBSOLETE create a simple 'TIME' time series
#'
#' @param x a numeric vector
#' @param startdate arguments passed to the zoo constructor
#' @return a very simple time series structure: data and start date
#' @export
#' @import zoo
timets <- function (x, startdate) {
  result <- x
  class(result)<-c(class(x), 'timets')
  attr(result, "startdate") <- as.Date(startdate)
  result
}
