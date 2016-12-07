## ----global options------------------------------------------------------
knitr::opts_chunk$set(echo = FALSE, message = FALSE,warning = FALSE, dev='CairoPDF')

## ----setenv, echo=FALSE, message=FALSE-----------------------------------
library(farsutil)

## ----summarize_data------------------------------------------------------
fars_summarize_years(c(2013,2014,2015))

## ----mapping_fatalities--------------------------------------------------
require(maps)
fars_map_state(48, 2014)  # Texas
fars_map_state(6, 2015)   # California

