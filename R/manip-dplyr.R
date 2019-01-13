#' @export

select.cross_section <- function(x, ...) {
  
  x$data <- select(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

slice.cross_section <- function(x, ...) {
  
  x$data <- slice(x$data, !!!enquos(...))
  
  x <- .update_meta(x)
  
  x
  
}

#' @export

filter.cross_section <- function(x, ...) {
  
  x$data <- filter(x$data, !!!enquos(...))
  
  x <- .update_meta(x)

  x
  
}
