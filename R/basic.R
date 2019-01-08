# data generators
#-------------------------------------------------------------------------------

# data generator generic
data_generator <- function(data, ...) UseMethod("data_generator")

# data generator for data frame
data_generator.data.frame <- function(

  data, x, y, batch_size = 32, shuffle = TRUE,
  output = "all", ...

  ) {
    
  # input args
  input_args <- list(...)

  # handle data input
  data <- handle_data_input(data, input_args)
  
  # generator args
  args <- list(
    data = data,
    x = x,
    y = y,
    batch_size = batch_size,
    shuffle = shuffle,
    output = output
  )
  
  # set class
  class(args) <- "data_generator"
  
  # build the generator
  build_generator(args)
  
}

# data generator default
data_generator.default <- function(data, ...) {
  
  stop("'data' must be an object of 'data.frame' or 'matrix'")
  
}

# data generator input handler
#-------------------------------------------------------------------------------

# input handler generic
handle_data_input <- function(data, ...) UseMethod("handle_data_input")

# input handler for data frame
handle_data_input.data.frame <- function(data, input_args) {
  
  # handle the inputs
  if (!is.null(input_args$index)) data <- data[input_args$index, ]
  if (!is.null(input_args$prep_funs)) data <- input_args$prep_funs(data)
  
  # convert to matrix
  data <- data.matrix(data)
  
  # strip row names
  rownames(data) <- NULL
  
  # processed data
  return(data)
  
}

# data generators builders
#-------------------------------------------------------------------------------

#
build_generator <- function(args) UseMethod("build_generator")

#
build_generator.data_generator <- function(args) {
  
  # get all args
  data <- args$data
  x <- args$x
  y <- args$y
  batch_size <- args$batch_size
  shuffle <- args$shuffle
  output <- args$output
  
  # start iterator
  i <- 1
  
  # return specified generator
  generator <- function() {
  
    # reset iterator if already seen all data
    if ((i + batch_size - 1) > nrow(data)) i <<- 1

    # iterate current batch's rows
    if (shuffle) rows <- sample(c(i:min(i + batch_size - 1, nrow(data))))
    else rows <- c(i:min(i + batch_size - 1, nrow(data)))
    
    # update to next iteration
    i <<- i + batch_size

    # get current batch
    batch <- data[rows, ]
    
    # split to x and y arrays
    if (output %in% c("x", "all")) x_array <- batch[, x]
    if (output %in% c("y", "all")) y_array <- batch[, y]
    
    # return the batch
    if (output == "x") list(x_array)
    else if (output == "y") list(y_array)
    else if (output == "all") list(x_array, y_array)

  }
  
  # set generator class
  class(generator) <- c("data_generator", class(generator))
  
  # return the generator
  return(generator)

}
