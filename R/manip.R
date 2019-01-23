# select x and y ---------------------------------------------------------------

#' @title Select feature and target for x and y arrays
#'
#' @description Select variables for x and y arrays with `dplyr`-like API
#'
#' @family manipulation
#'
#' @param x A keras generator object
#' @param ... Variable(s) of selection
#'
#' @return An updated keras generator object
#'
#' @name select_x_y
#' @rdname select_x_y
#'
#' @importFrom rlang enquos
#' @export

select_x <- function(x, ...) {
  
  # apply x array selection
  x$x_select <- enquos(...)

  # update meta
  set_meta(x)
  
}

#' @rdname select_x_y
#' @export

select_y <- function(x, ...) {
  
  # apply y array selection
  x$y_select <- enquos(...)
  
  # update meta
  set_meta(x)
  
}
