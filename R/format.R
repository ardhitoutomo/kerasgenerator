#' @export

print.kg_xs <- function(x, ...) {
  
  n_array <- sum(!is.null(x$preview$x), !is.null(x$preview$y))
  
  cat("A keras generator with:", "\n")
    
  cat("- Number of arrays:", n_array, "\n")
  cat("- Steps to see all data:", x$steps_to_all, "steps", "\n")
  
  cat("\n")
  
  cat("Batch", enclose(x$partition, x$steps_to_all), "preview:", "\n")
  
  cat("\n")
    
  print(x$preview$data)
  
  if (!is.null(x$preview$x)) {
    
    cat("\n")
    
    x_dim <- c(nrow(x$preview$x), ncol(x$preview$x))
    
    cat("X array with", enclose(x_dim, sep = ", "), "dimension", "\n")
    
    cat("\n")
    
    print(x$preview$x)
    
  }
  
  if (!is.null(x$preview$y)) {
    
    cat("\n")
    
    y_dim <- enclose(nrow(x$preview$y), ncol(x$preview$y), sep = ", ")
    
    cat("Y array with", y_dim, "dimension", "\n")
    
    cat("\n")
    
    print(x$preview$y)
    
  }

  
}
