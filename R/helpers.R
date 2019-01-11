# select column handler
#-------------------------------------------------------------------------------

# select handler
.select_handler <- function(data, x, y) {
  
  # force to integer
  if (is.character(x)) x <- which(colnames(data) %in% x)
  if (is.character(y)) y <- which(colnames(data) %in% y)
  
  # get selected list
  selected <- list(
    x = x,
    y = y,
    x_names = colnames(data)[x],
    y_names = colnames(data)[y]
  )
  
  # return the output
  return(selected)
  
}

# slice row handler
#-------------------------------------------------------------------------------

# slice row generic
.slice_handler <- function(index, ...) UseMethod(".slice_handler")

# slice row for integer index
.slice_handler.integer <- function(index, ...) {
  
  # get input
  input_list <- list(...)
  
  # handle the inputs
  data <- input_list$data[index, ]
  
  # processed data
  return(data)
  
}

# slice row for integer index
.slice_handler.NULL <- function(index, ...) {
  
  # get input
  input_list <- list(...)
  
  # processed data
  return(input_list$data)
  
}

# undefined method
.slice_handler.default <- function(index, ...) {
  
  # give stop message
  stop(paste("no default method for 'index' with class:", class(index)))
  
}
