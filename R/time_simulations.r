
#' Load the TIME2R CLR assembly
#'
#' @export
loadTime2RFacade <- function() {
  nativeLibsPath <- getNativeLibsPath('Time2R')
  r_arch=Sys.getenv("R_ARCH")
  f <- file.path(nativeLibsPath, ifelse( r_arch=='', '', '..'), 'CSIRO.TIME2R.dll')
  stopifnot( file.exists(f) )
  clrLoadAssembly(f)
}

simulationLoaderTypename <- 'CSIRO.TIME2R.SimulationLoader,CSIRO.TIME2R'
timeDataConvTypename <- 'CSIRO.TIME2R.TimeToRDataConversion,CSIRO.TIME2R'
timeSeriesHelperTypename <- 'CSIRO.TIME2R.TimeSeriesHelper,CSIRO.TIME2R'

#' Load a system runner simulation from an XML file
#'
#' @param filename path to XML serialization of a TIME simulation
#' @return a clr object implementing IPointTimeSeriesSimulation
#' @export
#' @import rClr
loadSystemRunner <- function(filename) {
  loadSimulation( 'LoadSystem', filename )
}

#' Load a system runner simulation from an XML file
#'
#' @param filename path to XML serialization of a TIME simulation
#' @return a clr object implementing IPointTimeSeriesSimulation
#' @export
#' @import rClr
loadModelRunner <- function(filename) {
  loadSimulation( 'LoadModel', filename )
}

#' Turn on/off whether new TIME model runners created will seek fastest runs by default
#'
#' Turn on/off whether new TIME model runners created will seek fastest runs by default. 
#' This is not always possible to take advantage off depending on the data that has been loaded. 
#' For most daily point time series model inputs/ouputs, this is usually possible to run faster. 
#' TIME will fall back on slower but working methods if it has to.
#'
#' @param enable TRUE or FALSE. TRUE by default.
#' @export
#' @import rClr
setFastModelRunner <- function(enable=TRUE) {
  clrCallStatic(simulationLoaderTypename, 'EnableFastExecution', enable)
}

#' Create a TIME Model runner
#'
#' Create a TIME Model runner
#'
#' @param type a System.Type object, type of the model in TIME
#' @return a clr object implementing IPointTimeSeriesSimulation
#' @export
createModelRunner <- function(type) {
  clrCallStatic(simulationLoaderTypename, 'CreateModelRunner', type)
}

#' Rewinds, reset and initialise states of a ModelRunner.
#'
#' Rewinds the model, then call reset and initialiseSimulation on the model that the ModelRunner uses.
#'
#' @param simul CLr object of type ModelRunner
#' @export
rewindModelRunner <- function(simul) {
  clrCall(simul, 'rewind')
  m <- clrGet(simul, 'Model')
  clrCall(m, 'reset')
  invisible(clrCall(simul, 'initialiseSimulation'))
}

#' Executes a temporal simulation
#'
#' Executes a temporal simulation
#'
#' @param simul a clr object implementing IPointTimeSeriesSimulation
#' @export
executeSimulation <- function(simul) {
  invisible(clrCall(simul, 'Execute'))
}

#' Run one time step of a ModelRunner temporal simulation
#'
#' Run one time step of a ModelRunner temporal simulation
#'
#' @param modelRunner a TIME model runner
#' @param sDate the simulation date
#' @export
runTimeStep <- function(modelRunner, sDate) {
  invisible(clrCall(modelRunner, 'runTimeStep', sDate))
}

#' Sets the temporal span of the model simulation
#'
#' Sets the temporal span of the model simulation
#'
#' @param simulation a TIME ModelRunner object
#' @param startDate The start of the simulation
#' @param endDate last day of the simulation
#' @export
setSimulSpan <- function(simulation, startDate, endDate) {
  invisible(clrCall(simulation, 'SetPeriod', as.Date(startDate), as.Date(endDate)))
}

loadSimulation <- function(methodName, filename) {
  clrCallStatic(simulationLoaderTypename, methodName, filename)
}

#' Gets a time series of the simulation output
#'
#' Gets a time series of the simulation output
#'
#' @param simulation a object implementing the IPointTimeSeriesSimulation interface
#' @param varName name of the output variable recorded to a time series. If missing, all the recorded time series will be returned.
#' @return a zoo DAILY time series, possibly with multiple variables.
#' @export
#' @import rClr
getRecordedTimeSeries <- function(simulation, varName) {
  if(missing(varName)) {
    getAllRecorded(simulation)
  } else {
    ttsToZoo(getRecordedTts(simulation, varName))
  }
}

internalGetRecordedTts <- function(simulation, varName) {
  stopifnot(length(varName)==1)
  ttsToZoo(getRecordedTts(simulation, varName))
}

getAllRecorded <- function(simulation) {
  allRec <- clrCall(simulation,"GetRecordedVariableNames")
  if(length(allRec)==0) { return(list()) }
  rects = lapply(allRec, FUN=function(name) {internalGetRecordedTts(simulation, name)} ) 
  names(rects) <- allRec
  result <- rects[[1]]
  for (i in 2:length(rects)) {result <- merge(result, rects[[i]]) }
  names(result) <- allRec
  result
}


