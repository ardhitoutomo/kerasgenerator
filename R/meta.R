#' @export

set_meta <- function(x) UseMethod("set_meta")

#' @importFrom rlang !!!
#' @export

set_preview <- function(x, data, ...) UseMethod("set_preview", data)

#' @export

set_preview.tbl_df <- function(x, data, ...) {
  
  # preview original data
  x$preview <- list(data = x$data[x$rows, ])
  
  # handle recipes
  if (!is.null(x$rec))
  
    x$preview$data <- bake(x$rec, x$preview$data)
  
  # preview x and y
  if (!is.null(x$x_select))
  
    x$preview$x <- select(x$preview$data, !!!x$x_select)
    
  if (!is.null(x$y_select))
  
    x$preview$y <- select(x$preview$data, !!!x$y_select)
  
  x
  
}

#' @export

set_preview.default <- function(x, data, ...)

  stop("unsupported data class")
