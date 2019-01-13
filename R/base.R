#' @export

keras_generator <- function(
  
  data, model = "cross_section", batch_size = 32,
  shuffle = TRUE, seed = 1, ...

  ) {
    
    if (!is_tibble(data)) data <- as_tibble(data)
  
    x <- structure(
      .Data = c(as.list(environment()), list(...)),
      class = c("keras_generator", model)
    )
    
    x <- .set_meta(x)
    
    x
    
}
