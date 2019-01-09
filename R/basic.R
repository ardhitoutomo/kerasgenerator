# data generators
#-------------------------------------------------------------------------------

# data generator for data frame
data_generator <- function(

  data, x, y, batch_size = 32, shuffle = TRUE,
  output = "all", range, index, prep_funs

  ) {
    
  # handle data input
  data <- .subset_handler(
    range = if (!missing(range)) range else NULL,
    index = if (!missing(index)) index else NULL,
    data = data
  )
  
  # generator args
  args <- list(
    data = data,
    x = x,
    y = y,
    batch_size = batch_size,
    shuffle = shuffle,
    output = output,
    prep_funs = if (!missing(prep_funs)) prep_funs else NULL
  )
  
  # set class
  class(args) <- "data_generator"
  
  # build the generator
  .build_generator(args)
  
}

# data generator input handler
#-------------------------------------------------------------------------------

# input handler generic
.subset_handler <- function(range, ...) UseMethod(".subset_handler")

# input handler for integer index
.subset_handler.integer <- function(range, ...) {
  
  # get input
  input_list <- list(...)
  
  # handle the inputs
  data <- input_list$data[range, ]
  
  # processed data
  return(data)
  
}

# input handler for integer index
.subset_handler.NULL <- function(range, ...) {
  
  # get input
  input_list <- list(...)
  
  # processed data
  return(input_list$data)
  
}

# undefined method
.subset_handler.default <- function(range, ...) {
  
  # give stop message
  stop(paste("no default method for 'range' with class:", class(range)))
  
}

# data generators builders
#-------------------------------------------------------------------------------

# generator builder generic
.build_generator <- function(args) UseMethod(".build_generator")

# generator builder for 'data_generator'
.build_generator.data_generator <- function(args) {
  
  # start iterator
  i <- 1
  
  # return specified generator
  generator <- function(reset = FALSE) {
    
    # force reset
    if (reset) {
      
      # reset iterator to 1
      i <<- 1
      
      # reset the reset
      reset <<- FALSE
      
      # give reset message
      return("reset to first batch")
      
    }
  
    # reset iterator if already seen all data
    if ((i + args$batch_size - 1) > nrow(args$data)) i <<- 1

    # iterate current batch's rows
    if (args$shuffle)
      
      rows <- sample(c(i:min(i + args$batch_size - 1, nrow(args$data))))
      
    else
    
      rows <- c(i:min(i + args$batch_size - 1, nrow(args$data)))
    
    # update to next iteration
    i <<- i + args$batch_size

    # get current batch
    batch <- args$data[rows, ]
    if (!is.null(args$prep_funs)) batch <- args$prep_funs(batch)
    if (!is.matrix(batch)) batch <- data.matrix(batch)
    
    # create container arrays
    if (args$output %in% c("x", "all"))
    
      x_array <- array(0, dim = c(nrow(batch), length(args$x)))
      
    if (args$output %in% c("y", "all"))
    
      y_array <- array(0, dim = c(nrow(batch), length(args$y)))
      
    # split to x and y arrays
    if (args$output %in% c("x", "all")) x_array[, ] <- batch[, args$x]
    if (args$output %in% c("y", "all")) y_array[, ] <- batch[, args$y]
    
    # return the batch
    if (args$output == "x") list(x_array)
    else if (args$output == "y") list(y_array)
    else if (args$output == "all") list(x_array, y_array)

  }
  
  # set generator class
  class(generator) <- c("data_generator", "function")
  
  # return the generator
  return(generator)

}

# generator modifyer
#-------------------------------------------------------------------------------

# modifyer generic
modify_generator <- function(generator, ...) UseMethod("modify_generator")

# modifyer for data_generator
modify_generator.data_generator <- function(generator, reset, ...) {
  
  # get all generator opts
  opts <- list(...)
  
  # reset the generator
  if (!missing(reset)) generator(reset = reset)
  
  # return back the generator
  return(generator)
  
}
