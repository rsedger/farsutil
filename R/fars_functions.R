#' (Internal use only) fars_read reads in a FARS data file
#' @param filename A string which represents a file name
#' @note If the file does not exist the function exits
#' @importFrom dplyr tbl_df
#' @importFrom readr read_csv
#' @return a data.frame
#' @export
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}
#' (Internal use only) make_filename Creates a filename with the correct structure for FARS data
#' @param year A 4-digit year, e.g., 2015
#' @return a string which represents a FARS data file name
#' @export
make_filename <- function(year) {
        year <- as.integer(year)
        filename <- sprintf("accident_%d.csv.bz2", year)
        full_filename <- system.file('extdata', filename, package = 'farsutil')
        full_filename
}
#' (Internal use only) fars_read_years extracts data by year
#' @param years A year or a list of years in the range 2013 to 2015
#' @note If the year is invalid the function exits with a warning
#' @importFrom magrittr "%>%"
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @return This function returns a list of tibbles, where each tibble
#'   contains the year and month from the observations in the corresponding
#'   year's FARS data. If the year is not valid, the list will be NULL.
#' @export
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select_(~ MONTH, ~ year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}
#' fars_summarize_years creates a summary from FARS data files. For
#'     each year given, a monthly total of fatalities is returned.
#' @param years A year or a list of years from 2013 to 2015 inclusive.
#' @importFrom magrittr "%>%"
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr bind_rows
#' @importFrom tidyr spread
#' @return summary of fatalities by month and year, a 12 x number of years
#'     tibble.
#' @examples
#' fars_summarize_years(2015)
#' fars_summarize_years(c(2013,2014,2015))
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by_(~ year, ~ MONTH) %>%
                dplyr::summarize_(n = ~ n()) %>%
                tidyr::spread_('year', 'n')
}
#' fars_map_state creates a map of fatalities in a state
#' @param state.num A state number
#' @param year One of 2013, 2014, or 2015
#' @importFrom maps map
#' @importFrom dplyr filter
#' @importFrom graphics points
#' @return a map of the fatalities in the state represented by state.num
#' @examples
#' require(maps)
#' fars_map_state(48, 2013)
#' fars_map_state(6, 2015)
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter_(data, ~ STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}