#' Function called when loading the RtoTIME package with 'library'. 
#'
#' @rdname dotOnLoad.Rd
#' @param libname the path to the library from which the package is loaded
#' @param pkgname the name of the package.
.onLoad <- function(libname='~/R', pkgname='RtoTIME') {
  libLocation<-system.file(package=pkgname)
  libpath <- file.path(libLocation, 'libs')
  f <- file.path(libpath, 'CSIRO.TIME2R.dll')
  if( !file.exists(f) ) {
    packageStartupMessage('Could not find path to CSIRO.TIME2R.dll, you will have to load it manually')
  } else {
    clrLoadAssembly(f)
  }
}
