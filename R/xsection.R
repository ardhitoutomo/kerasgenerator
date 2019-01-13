#' @export

xsection_generator <- function(data, batch_size = 32,
                               shuffle = TRUE, seed = 1) {
  
  data <- .as_generator_input(data)

  x <- as.list(environment())
  
  class(x) <- c("keras_generator", "xsection_generator")
  
  x <- .set_meta(x)
  
  x
  
}
