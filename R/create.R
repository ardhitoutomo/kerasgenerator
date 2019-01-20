# cross-section generator ------------------------------------------------------

#' @title Create a cross-sectional data generator meta
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

create_generator <- function(data, batch_size = 32,
                             shuffle = TRUE, seed = 1) {
  
  # wrap-up
  x <- structure(as.list(environment()), class = c("tbl_kg", "kg_xs"))
  
  # set initial meta
  set_meta(x)
  
}
