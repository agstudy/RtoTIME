\name{recordTimeSeries}
\alias{recordTimeSeries}
\title{Flag a model output to be recorded at the next simulation execution}
\usage{
  recordTimeSeries(simulation, varName = "runoff")
}
\arguments{
  \item{simulation}{a object implementing the
  IPointTimeSeriesSimulation interface, for instance a
  ModelRunner object}

  \item{varName}{name(s) of the output variable(s) recorded
  to a time series.}
}
\description{
  Flag a model output to be recorded at the next simulation
  execution
}

