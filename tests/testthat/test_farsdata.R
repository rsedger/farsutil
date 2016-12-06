context('Errors')

test_that('Throws errors', {
  throws_error(fars_read_years(years = 2014)) # func not exported
  throws_error(fars_summarize_years(years = 2010))
  throws_error(make_filename(year = 'nineteen ninety nine'))

  library(maps)
  throws_error(fars_map_state(6, 2010))
  throws_error(fars_map_state(3, 2014))
})

context('File load and summary are correct')

test_that('FARS Summarize Years is correct', {
  years <- c(2013,2014,2015)
  df <- fars_summarize_years(years)
  expect_that(nrow(df), equals(12))
  expect_that(ncol(df), equals(length(years) + 1))
  expect_that(names(df)[1], matches('MONTH'))
})

test_that('Mapping works', {
  library(maps)
  map <- fars_map_state(42, 2015)
  expect_that(map, is_null())
})
