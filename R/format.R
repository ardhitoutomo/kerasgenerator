#' @export

glimpse.keras_generator <- function(x, ...) {
  
  cat("A keras generator with:", "\n")
    
  cat("- Number of arrays:", sum(!is.null(x$x), !is.null(x$y)), "\n")
  cat("- Steps to see all data:", x$steps_to_all, "steps", "\n")
  
  cat("\n")
    
  NextMethod()
  
}

#' @export

glimpse.cross_section <- function(x, ...) {
  
  cat("Batch", .enclose(x$partition, x$steps_to_all), "preview:", "\n")
  
  cat("\n")
    
  glimpse(x$preview$data)
  
  if (!is.null(x$preview$x)) {
    
    cat("\n")
    
    x_dim <- .enclose(nrow(x$preview$x), ncol(x$preview$x), sep = ", ")
    
    cat("X array with", x_dim, "dimension", "\n")
    
    cat("\n")
    
    glimpse(x$preview$x)
    
  }
  
  if (!is.null(x$preview$y)) {
    
    cat("\n")
    
    y_dim <- .enclose(nrow(x$preview$y), ncol(x$preview$y), sep = ", ")
    
    cat("Y array with", y_dim, "dimension", "\n")
    
    cat("\n")
    
    glimpse(x$preview$y)
    
  }
  
}

#' @export

print.keras_generator <- function(x, ...) glimpse(x)

#' @export

head.keras_generator <- function(x, ...) glimpse(x)
