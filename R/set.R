# cross-section generator ------------------------------------------------------

#' @title Set-up a cross-sectional data generator meta
#'
#' @description An initial function to define a cross-sectional data generator
#'
#' @family cross-section generator
#'
#' @param data A `data.frame` or `tbl` containing the cross-sectional data
#' @param batch_size An `integer` value indicating how many observation is
#'  considered as a batch
#' @param shuffle A `logical` indicating whether to shuffle the observation
#'  within the batch
#' @param seed An optional `integer` value for passing to `set.seed()` if
#'  `shuffle` is `TRUE`
#'
#' @return A keras generator meta
#'
#' @export

set_generator <- function(data, batch_size = 32,
                          shuffle = TRUE, seed = 1) {
  
  # wrap-up
  x <- structure(as.list(environment()), class = c("tbl_kg", "kg_xs"))
  
  # set initial meta
  set_meta(x)
  
}

# time series generator --------------------------------------------------------

#' @title Set-up a time series data generator meta
#'
#' @description An initial function to define a cross-sectional data generator
#'
#' @family cross-section generator
#'
#' @param data A `data.frame` or `tbl`, or `tbl_ts` containing
#'  the time series data
#' @param lookback A `numeric` vector which identify the number
#'  of lookback period
#' @param timesteps A `numeric` vector which identify the number
#'  of timesteps length
#' @inheritParams set_data_generator
#'
#' @return A keras generator meta
#'
#' @export

set_series_generator <- function(data, lookback = 1, timesteps = 1,
                                 batch_size = 32, shuffle = TRUE, seed = 1) {
  
  # wrap-up
  x <- structure(as.list(environment()), class = c("tbl_kg", "kg_ts"))
  
  # set initial meta
  set_meta(x)
  
}
