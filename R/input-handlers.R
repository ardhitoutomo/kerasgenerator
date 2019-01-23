#' @keywords internal
#' @export

handle_data_size <- function(x, data, ...) UseMethod("handle_data_size", data)

#' @export

handle_data_size.tbl_df <- function(x, data, ...) {

  # get data size
  x$data_size <- nrow(data)
  
  x
  
}

#' @importFrom tibble as_tibble
#' @export

handle_data_size.data.frame <- function(x, data, ...) {
  
  # coerce to tibble
  x$data <- as_tibble(x$data)
  
  # next method
  handle_data_size(x, x$data)
  
}

#' @export

handle_data_size.default <- function(x, data, ...)

  stop("unsupported input class")
