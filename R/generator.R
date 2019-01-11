# data generator builders
#-------------------------------------------------------------------------------

#' @export

# generator builder generic
.build_generator <- function(args) UseMethod(".build_generator")

#' @export

# generator builder for 'data_generator'
.build_generator.data_generator <- function(args) {
  
  
  # generator metadata
  steps_to_all <- ceiling(nrow(args$data) / args$batch_size)
  batch_nth <- 1
  
  # start iterator
  i <- 1
  
  # return specified generator
  generator <- function(reset = FALSE) {
    
    # force reset
    if (reset) {
      
      # reset iterator to 1
      i <<- 1
      batch_nth <<- 1
      
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
    
    # get current batch
    batch <- args$data[rows, ]
    if (!is.null(args$prep_funs)) batch <- args$prep_funs(batch)
    if (!is.matrix(batch)) batch <- data.matrix(batch)
    
    # create output container
    batch_list <- list()

    # fill the container
    if (args$output %in% c("x", "all")) {
    
      x_array <- array(0, c(nrow(batch), length(args$x)))
      x_array[, ] <- batch[, args$x]
      
      batch_list$x_array <- x_array
      
    }
    
    if (args$output %in% c("y", "all")) {
    
      y_array <- array(0, c(nrow(batch), length(args$y)))
      y_array[, ] <- batch[, args$y]
      
      batch_list$y_array <- y_array
      
    }
    
    # set class
    batch_list <- structure(
      .Data = batch_list,
      class = c("kerasgenerator_batch", "list"),
      batch_nth = batch_nth
    )
    
    # keep var names
    if (args$output %in% c("x", "all"))
      
      attr(batch_list, "x_names") <- args$x_names
    
    if (args$output %in% c("y", "all"))
      
      attr(batch_list, "y_names") <- args$y_names
    
    # set current iteration metadata
    attr(batch_list, "batch_nth") <- batch_nth
    attr(batch_list, "steps_to_all") <- steps_to_all
    
    # update to next iteration
    i <<- i + args$batch_size
    batch_nth <<- batch_nth + 1

    # return the batch
    return(batch_list)

  }
  
  # set generator class
  class(generator) <- c("data_generator", "function")
  
  # return the generator
  return(generator)

}
