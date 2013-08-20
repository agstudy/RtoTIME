# RtoTIME

**RtoTIME** is an R package to access environmental modelling components in TIME. TIME (The Invisible Modelling Environment) is a modelling framework running on Microsoft .NET and Mono.

TIME is currently hosted on a private repository on Bitbucket. Contact [eWater](http://www.ewater.com.au) if you wish to request access to the source code; however this is not compulsory to use this package and TIME binaries can be directly used instead.

CSIRO employee only: specific information should be available [here](https://wiki.csiro.au/display/~per202/TIME+from+R)

## Prerequisites and package dependencies

The RtoTIME package uses the .NET framework SDK to build some C# code. Typically if you have on your machine the file "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe", you can skip this paragraph. Otherwise you need to install the [Microsoft Windows SDK for Windows 7 and .NET Framework 4](http://www.microsoft.com/en-us/download/details.aspx?id=8279). An overview of list of Microsoft SDKs is available [here](http://msdn.microsoft.com/en-us/vstudio/hh487283.aspx)

The interoperability of R and .NET code relies on the [rClr](http://r2clr.codeplex.com/) R package. As of 2013-08-19 you can download an installable R package for windows (zip file). Make sure to at least skim through the [installation instructions](http://r2clr.codeplex.com/wikipage?title=Installing%20R%20packages&referringTitle=Documentation).

Another package dependency is the well-known zoo package

```S
install.packages("zoo") # you don't need to run this command if you already have the zoo package installed.
```

## Install

### Install from precompiled RtoTIME

### Compile and install from source

Check out the RtoTIME package from its [github repository](http://someaddress.net) to a folder of your choice. Note that, if you already use the `devtools` package, using the `install_github` function to install RtoTIME is is _not yet_ possible; you need a customisation step as follows.

You need to specify the location of your TIME binaries. In the file "RtoTIME\src\CSIRO.TIME2R\time2r.props", replace "F:\WRAA\bin" with a path where the assembly TIME.Tools.dll and its dependencies are present.

```xml
  <PropertyGroup Label="UserMacros">
    <TIMEBinariesPath>F:\WRAA\bin</TIMEBinariesPath>
  </PropertyGroup>
```

Building from the Windows CMD prompt:

```bat
F:
cd F:\path\to\the\package
REM R.exe for either architecture is fine.
set R="c:\Program Files\R\R-3.0.0\bin\x64\R.exe"
REM optionally, but preferably, check the package
%R% CMD check RtoTIME
%R% CMD INSTALL RtoTIME
```

Or, if you use devtools:

```S
library(devtools)
mhdir <- 'F:/path/to/the/package' # i.e. F:/path/to/the/package contains the package folder RtoTIME
install(file.path(mhdir, 'RtoTIME'))
```

## Examples

```S
require(RtoTIME)

# load an assembly with rainfall runoff models
libs <- system.file('libs', package='RtoTIME')
dllName <- file.path(libs, "TIME.Models.RainfallRunoff.dll")
stopifnot(file.exists(dllName))
clrLoadAssembly(dllName)

# create a model simulation
# Note to self: needs more convenience methods in the API
mtype <- clrGetType("TIME.Models.RainfallRunoff.AWBM.AWBM")
if (is.null(mtype)) {stop('Failed to find the model Type')}
mr <- createModelRunner(mtype)

# Set time series inputs
data('catchment-data')
plot(catData)
startDate <- as.Date('1993-01-01')
endDate <- as.Date('1999-01-01')
d <- window(catData, start=startDate, end=endDate)

playTimeSeries(mr, 'rainfall', zooToDailyTts(d[,'Rain']))
playTimeSeries(mr, 'evapotranspiration', zooToDailyTts(d[,'Pet'])) # not right, but for demo only
recordTimeSeries(mr, 'runoff')
# note to self TODO: playTimeSeries(mr, 'rainfall', zooToDailyTts(d['Rain']))  needs check. Note the missing comma in d['Rain'] instead of  d[,'Rain']

# Run it
executeSimulation(simul=mr)

# Plot runoff data
runoff <- getRecordedTimeSeries(mr, 'runoff')
# a workaround to overcome varying date representations...
index(d) <- index(runoff)
z <- merge(runoff, d[,'QObs'])
plot(z, plot.type='single', col=c('red','blue'))
```

```S
```

## Resources

## Acknowledgements
