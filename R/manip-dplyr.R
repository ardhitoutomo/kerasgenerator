#' @importFrom rlang !!! enquos
#' @export

filter.tbl_kg <- function(x, ...) {
  
  # apply filter
  x$data <- filter(x$data, !!!enquos(...))
  
  # update meta
  set_meta(x)
  
}

#' @export

group_by.tbl_kg <- function(x, ...) {
  
  # apply group_by
  x$data <- group_by(x$data, !!!enquos(...))
  
  # update meta
  set_meta(x)
  
}

#' @export

mutate.tbl_kg <- function(x, ...) {
  
  # apply mutate
  x$data <- mutate(x$data, !!!enquos(...))
  
  # update meta
  set_meta(x)
  
}

#' @export

select.tbl_kg <- function(x, ...) {
  
  # apply select
  x$data <- select(x$data, !!!enquos(...))
  
  # update meta
  set_meta(x)
  
}

#' @export

slice.tbl_kg <- function(x, ...) {
  
  # apply slice
  x$data <- slice(x$data, !!!enquos(...))
  
  # update meta
  set_meta(x)
  
}

#' @importFrom rlang eval_tidy quo
#' @export

slice.kg_ts <- function(x, ...) {
  
  # readjust selected rows
  rows <- eval_tidy(quo(...))
  
  rows <- c((min(rows) - x$lookback - x$timesteps + 1):max(rows))
  
  # apply slice
  x$data <- slice(x$data, rows)
  
  # update meta
  set_meta(x)
  
}

#' @export

summarise.tbl_kg <- function(x, ...) {
  
  # apply summarise
  x$data <- summarise(x$data, !!!enquos(...))
  
  # update meta
  set_meta(x)
  
}
