## farsutil Package - A Coursera Project

This R package is the final assignment for the "Building R Packages" Coursera course from Johns Hopkins University. "Building R Packages" is part of the  "Mastering Software Development in R" specialization.

Date: Dec 7, 2016 

### Installation

To install this package: 

```R
install_github('rsedger/farsutil')
library(farsutil)
```

The data associated with this package may be accessed as follows:
```R
system.file("extdata", "accident_2013.csv.bz2", package = "farsutil")
system.file("extdata", "accident_2014.csv.bz2", package = "farsutil")
system.file("extdata", "accident_2014.csv.bz2", package = "farsutil")
```

### Vignette

To get started, read the introduction vignette: `vignette('overview', package = 'farsutil')`.


### Travis Badge

[![Build Status](https://travis-ci.org/rsedger/farsutil.svg?branch=master)](https://travis-ci.org/rsedger/farsutil)


