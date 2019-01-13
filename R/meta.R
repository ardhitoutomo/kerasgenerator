#' @export

.set_meta <- function(x) UseMethod(".set_meta")

#' @export

.set_meta.xsection_generator <- function(x) {
  
  x$steps_to_all <- ceiling(nrow(x$data) / x$batch_size)
  
  x$partition <- 1
  
  x$i <- seq(1, by = x$batch_size, length.out = x$steps_to_all)
  
  x$j <- c(x$i[-length(x$i)] + x$batch_size - 1, nrow(x$data))
  
  if (x$shuffle) {
    
    set.seed(x$seed)
    
    x$rows <- sample(x$i[x$partition]:x$j[x$partition])
    
  } else {
  
    x$rows <- c(x$i[x$partition]:x$j[x$partition])
    
  }
  
  x$preview <- list(data = x$data[x$rows, ])
  
  x
  
}

#' @export

.update_meta <- function(x) UseMethod(".update_meta")

#' @export

.update_meta.xsection_generator <- function(x) {
  
  x$steps_to_all <- ceiling(nrow(x$data) / x$batch_size)
  
  x$i <- seq(1, by = x$batch_size, length.out = x$steps_to_all)
  
  x$j <- c(x$i[-length(x$i)] + x$batch_size - 1, nrow(x$data))
  
  if (x$shuffle) {
    
    set.seed(x$seed)
    
    x$rows <- sample(x$i[x$partition]:x$j[x$partition])
    
  } else {
  
    x$rows <- c(x$i[x$partition]:x$j[x$partition])
    
  }
  
  x$preview <- list(data = x$data[x$rows, ])
  
  if (!is.null(x$rec))
  
    x$preview$data <- bake(x$rec, x$preview$data)
  
  if (!is.null(x$x_select))
  
    x$preview$x <- select(x$preview$data, !!!x$x_select)
    
  if (!is.null(x$y_select))
  
    x$preview$y <- select(x$preview$data, !!!x$y_select)
    
  x
  
}

#' @export

.get_meta <- function(x) UseMethod(".get_meta")

#' @export

.get_meta.xsection_generator <- function(x) {
  
  as.list(environment(x))
  
}
