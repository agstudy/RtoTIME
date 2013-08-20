\name{tts}
\alias{tts}
\title{Create a 'TIME' time series}
\usage{
  tts(values, startDate, timestep)
}
\arguments{
  \item{values}{the numeric vector of values in the time
  series}

  \item{startDate}{Start date of the time series; an object
  coercible to a POSIXct representation.}

  \item{timeStep}{a case-sensitive string such as "Daily",
  "Monthly", or a clrobj with a CLR type TimeStep}
}
\value{
  a 'TIME' time series as a clrobj
}
\description{
  Create a 'TIME' time series
}

