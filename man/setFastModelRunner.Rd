\name{setFastModelRunner}
\alias{setFastModelRunner}
\title{Turn on/off whether new TIME model runners created will seek fastest runs by default}
\usage{
  setFastModelRunner(enable = TRUE)
}
\arguments{
  \item{enable}{TRUE or FALSE. TRUE by default.}
}
\description{
  Turn on/off whether new TIME model runners created will
  seek fastest runs by default. This is not always possible
  to take advantage off depending on the data that has been
  loaded. For most daily point time series model
  inputs/ouputs, this is usually possible to run faster.
  TIME will fall back on slower but working methods if it
  has to.
}

