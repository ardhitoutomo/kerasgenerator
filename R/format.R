#' @export

glimpse.data_generator <- function(x, ...) {
  
  # get sample batch
  batch <- x()

  # reset the generator
  reset_generator(x)

  # cat header
  cat("# A data generator with:", length(batch), "arrays\n")
  
  # glimpse example batch
  glimpse(batch)

}

#' @export

glimpse.kerasgenerator_batch <- function(x, ...) {

  # batch order
  batch_order <- paste0(
    "[", attr(x, "batch_nth"), "/", attr(x, "steps_to_all"), "]"
  )
  
  # cat header
  cat("# Batch", batch_order, "\n")

  # cat array glimpses
  if (!is.null(x$x_array)) {
  
    # get array dim
    x_dim <- paste0("[", paste(dim(x$x_array), collapse = ", "), "]")
  
    # convert to tibble
    x_array <- as_tibble(x$x_array)
    colnames(x_array) <- attr(x, "x_names")
    
    # glimpse header
    cat("\n# X array", x_dim, "\n")
    glimpse(x_array)
    
  }
  
  if (!is.null(x$y_array)) {
  
    # get array dim
    y_dim <- paste0("[", paste(dim(x$y_array), collapse = ", "), "]")

    # convert to tibble
    y_array <- as_tibble(x$y_array)
    colnames(y_array) <- attr(x, "y_names")
    
    # glimpse header
    cat("\n# Y array", y_dim, "\n")
    glimpse(y_array)
    
  }
  
}
