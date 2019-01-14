#' @export

select.keras_generator <- function(x, ...) {
  
  x$data <- select(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

mutate.keras_generator <- function(x, ...) {
  
  x$data <- mutate(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

filter.keras_generator <- function(x, ...) {
  
  x$data <- filter(x$data, !!!enquos(...))
  
  x <- .update_meta(x)

  x
  
}

#' @export

slice.keras_generator <- function(x, ...) {
  
  x$data <- slice(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

group_by.keras_generator <- function(x, ...) {
  
  x$data <- group_by(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

select_x <- function(x, ...) UseMethod("select_x")

#' @export

select_x.data_generator <- function(x, ...) {
  
  x$x_select <- enquos(...)
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

select_y <- function(x, ...) UseMethod("select_y")

#' @export

select_y.data_generator <- function(x, ...) {
  
  x$y_select <- enquos(...)
  
  x <- .update_meta(x)
  
  x
  
}
