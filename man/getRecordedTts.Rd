\name{getRecordedTts}
\alias{getRecordedTts}
\title{Retrieves a recorded 'TIME' time series from a simulation}
\usage{
  getRecordedTts(simulation, varName = "runoff")
}
\arguments{
  \item{simulation}{a object implementing the
  IPointTimeSeriesSimulation interface, for instance a
  ModelRunner object}

  \item{varName}{name of the output variable recorded to a
  time series.}
}
\value{
  a clrobj object
}
\description{
  Retrieves a recorded 'TIME' time series from a
  simulation. R users are likely to prefer
}

