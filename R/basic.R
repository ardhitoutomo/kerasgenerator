# data generators
#-------------------------------------------------------------------------------

#' @export

# data generator for data frame
data_generator <- function(

  data, x, y, batch_size = 32, shuffle = TRUE,
  output = "all", index, prep_funs

  ) {
  
  # select handler
  selected <- .select_handler(data, x, y)
  
  # handle data subset
  data <- .slice_handler(
    index = if (!missing(index)) index else NULL,
    data = data
  )
  
  # generator args
  args <- list(
    data = data,
    x = selected$x,
    y = selected$y,
    x_names = selected$x_names,
    y_names = selected$y_names,
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
