#' Load a parameter set from an XML file
#'
#' Load a parameter set from an XML file
#'
#' @param filename the file name of the XML werialisation of a TIME parameter set
#' @return a CLR object
#' @export
loadParameterSetFromXml <- function(filename) {
  clrCallStatic('CSIRO.TIME2R.ParameterSetHelper', 'LoadParameterSet', filename)
}

#' Convert a TIME parameter to a simple data frame representation
#'
#' Convert a TIME parameter to a simple data frame representation
#'
#' @param paramSet a CLR object of type ParameterSet
#' @return a data frame with column names Name,Value,Min,Max
#' @export
pSetAsDataFrame <- function(paramSet) {
  p <- clrCallStatic('CSIRO.TIME2R.ParameterSetHelper', 'PsetToDataFrame', paramSet)
  data.frame(Name=clrGet(p,'Name'), Value=clrGet(p,'Values'), Min=clrGet(p,'Minima'), Max=clrGet(p,'Maxima'),  Description=clrGet(p,'Description'),  stringsAsFactors=FALSE)
}

#' Gets a TIME parameter set from a model
#'
#' Gets a TIME parameter set from a model
#'
#' @param model A TIME model, usually; possibly an arbitrary CLR object
#' @return a CLR object of type ParameterSet
#' @export
getModelParameters <- function(model) {
  p <- clrCallStatic('CSIRO.TIME2R.ParameterSetHelper', 'CreateFrom', model)
}

#' Gets a simple data frame representation of model parameter
#'
#' Gets a simple data frame representation of model parameter
#'
#' @param model A TIME model, usually; possibly an arbitrary CLR object
#' @return a data frame with column names Name,Value,Min,Max
#' @export
getModelParametersAsDataFrame <- function(model) {
  pSetAsDataFrame(getModelParameters(model))
}

#' Gets a simple data frame representation of model parameter
#'
#' Gets a simple data frame representation of model parameter
#'
#' @param model A TIME model, usually; possibly an arbitrary CLR object
#' @param paramSetDataFrame a data frame with at least column names Name,Value
#' @export
pSetApplyDataFrame <- function(model, paramSetDataFrame) {
  # strings should not be factors in the data frame
  p <- paramSetDataFrame[,c('Name','Value')]
  p <- data.frame(Name=as.character(p[,'Name']), Value=p[,'Value'], stringsAsFactors=FALSE)
  for (i in 1:nrow(p)) {
    clrSet(model, p[i,'Name'], p[i,'Value'])
  }
}
