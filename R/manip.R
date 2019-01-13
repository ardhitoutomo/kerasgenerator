#' @export

select_x <- function(x, ...) UseMethod("select_x")

#' @export

select_x.cross_section <- function(x, ...) {
  
  x$x_select <- enquos(...)
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

select_y <- function(x, ...) UseMethod("select_y")

#' @export

select_y.cross_section <- function(x, ...) {
  
  x$y_select <- enquos(...)
  
  x <- .update_meta(x)
  
  x
  
}
