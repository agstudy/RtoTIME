\name{playTimeSeries}
\alias{playTimeSeries}
\title{Flag a model output to be recorded at the next simulation execution}
\usage{
  playTimeSeries(simulation, varName, timeSeries)
}
\arguments{
  \item{simulation}{a object implementing the
  IPointTimeSeriesSimulation interface, for instance a
  ModelRunner object}

  \item{varName}{name of the output variable recorded to a
  time series.}

  \item{timeSeries}{a TIME time series object, or a zoo
  time series.}
}
\value{
  a clrobj object pointing to a TIME time series containing
  the output
}
\description{
  Flag a model output to be recorded at the next simulation
  execution
}

