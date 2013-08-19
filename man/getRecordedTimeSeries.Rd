\name{getRecordedTimeSeries}
\alias{getRecordedTimeSeries}
\title{Gets a time series of the simulation output}
\usage{
  getRecordedTimeSeries(simulation, varName)
}
\arguments{
  \item{simulation}{a object implementing the
  IPointTimeSeriesSimulation interface}

  \item{varName}{name of the output variable recorded to a
  time series. If missing, all the recorded time series
  will be returned.}
}
\value{
  a zoo DAILY time series, possibly with multiple
  variables.
}
\description{
  Gets a time series of the simulation output
}

