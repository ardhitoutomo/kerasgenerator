#' @export

set_meta.kg_xs <- function(x) {
  
  # handle data size
  x <- handle_data_size(x, x$data)
  
  # set data profile
  x$steps_to_all <- ceiling(x$data_size / x$batch_size)
  
  x$partition <- 1
  
  x$i <- seq(1, by = x$batch_size, length.out = x$steps_to_all)
  
  x$j <- c(x$i[-length(x$i)] + x$batch_size - 1, x$data_size)
  
  if (x$shuffle) {
    
    set.seed(x$seed)
    
    x$rows <- sample(x$i[x$partition]:x$j[x$partition])
    
  } else {
  
    x$rows <- c(x$i[x$partition]:x$j[x$partition])
    
  }
  
  # set batch preview
  set_preview(x, x$data)
  
}
