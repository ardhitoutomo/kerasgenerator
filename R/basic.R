# basic data generator
data_generator <- function(

  data, x, y, index, start_index, end_index,
  shuffle = TRUE, batch_size = 32,
  return_target = TRUE, prep_funs = NULL

  ) {
  
  # stop if data is not a proper object
  if (!inherits(data, c("data.frame", "matrix")))
  
    stop("'data' must be an object of 'data.frame' or 'matrix'")
  
  # handle index arguments
  if (!missing(index)) {
    
    # stop if also specifying start and end index
    if (!missing(start_index) | !missing(end_index))
      
      stop("choose either give specific index, or start and end index")
    
    # subset data based on index
    data <- data[index, ]
    
  }
  
  # check start & end index
  if (missing(start_index)) start_index <- 1
  if (missing(end_index)) end_index <- nrow(data)
  
  # start iterator
  i <- start_index
  i_nth <- 1

  # return an iterator
  function() {
    
    # reset iterator if already seen all data
    if ((i + batch_size - 1) > end_index) i <<- start_index

    # iterate current batch's rows
    if (shuffle) rows <- sample(c(i:min(i + batch_size - 1, end_index)))
    else rows <- c(i:min(i + batch_size - 1, end_index))
    
    # update to next iteration
    i <<- i + batch_size
    i_nth <<- i_nth + 1

    # get current batch
    batch <- data[rows, ]
    
    # preprocess the batch
    if (!is.null(prep_funs)) batch <- prep_funs(batch)
    if (inherits(batch, "data.frame")) batch <- data.matrix(batch)

    # create container arrays
    x_array <- array(0, dim = c(nrow(batch), length(x)))
    if (return_target) y_array <- array(0, dim = c(nrow(batch), length(y)))
    
    # split to x and y arrays
    x_array[, ] <- batch[, x]
    if (return_target) y_array[, ] <- batch[, y]
    
    # return the batch
    if (!return_target) list(x_array)
    else list(x_array, y_array)

  }

}
