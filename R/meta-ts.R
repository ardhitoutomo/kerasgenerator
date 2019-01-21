#' @export

set_meta.kg_ts <- function(x) {
  
  # handle data size
  x <- handle_data_size(x, x$data)
  
  # set data profile
  x$steps_to_all <- ceiling(x$data_size / x$batch_size)
  
  x$partition <- 1
  
  y_start <- x$timesteps + x$lookback + 1
  
  x$i <- seq(y_start, by = x$batch_size, length.out = x$steps_to_all)
  
  x$j <- c(x$i[-length(x$i)] + x$batch_size - 1, x$data_size)
  
  if (x$shuffle) {
    
    set.seed(x$seed)
    
    x$y_rows <- sample(x$i[x$partition]:x$j[x$partition])
    
  } else {
  
    x$y_rows <- c(x$i[x$partition]:x$j[x$partition])
    
  }
  
  x$x_rows <- x$y_rows - x$lookback
  
  x$rows <- c(min(x$x_rows):max(x$y_rows))
  
  # set batch preview
  set_series_preview(x, x$data)
  
}

#' @importFrom rlang !!!
#' @export

set_series_preview <- function(x, data, ...)

  UseMethod("set_series_preview", data)

#' @export

set_series_preview.tbl_df <- function(x, data, ...) {
  
  # preview original data
  x$preview <- list(data = x$data[x$rows, ])
  
  # handle recipes
  if (!is.null(x$rec))
  
    x$preview$data <- bake(x$rec, x$preview$data)
  
  # preview x and y
  if (!is.null(x$x_select))
  
    x$preview$x <- select(x$preview$data[x$x_rows, ], !!!x$x_select)
    
  if (!is.null(x$y_select))
  
    x$preview$y <- select(x$preview$data[x$y_rows, ], !!!x$y_select)
  
  x
  
}
