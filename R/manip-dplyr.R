#' @export

select.xsection_generator <- function(x, ...) {
  
  x$data <- select(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

slice.xsection_generator <- function(x, ...) {
  
  x$data <- slice(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

filter.xsection_generator <- function(x, ...) {
  
  x$data <- filter(x$data, !!!enquos(...))
  
  x <- .update_meta(x)

  x
  
}

#' @export

select_x <- function(x, ...) UseMethod("select_x")

#' @export

select_x.xsection_generator <- function(x, ...) {
  
  x$x_select <- enquos(...)
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

select_y <- function(x, ...) UseMethod("select_y")

#' @export

select_y.xsection_generator <- function(x, ...) {
  
  x$y_select <- enquos(...)
  
  x <- .update_meta(x)
  
  x
  
}
