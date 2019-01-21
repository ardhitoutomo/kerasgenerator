# build series generator -------------------------------------------------------

#' @title Compile a time series keras generator meta into fully functional
#'  generator
#'
#' @param x A time series keras generator meta
#'
#' @return A fully functional time series keras generator object
#'
#' @name build
#' @rdname build
#'
#' @importFrom recipes bake
#' @importFrom rlang !!! enquos
#' @export

build_generator.kg_ts <- function(x, ...) {
  
  # unlist meta data to generator's env
  list2env(build_generator_env(x), environment())
  
  # remove unused meta list
  rm(x)

  # define generator
  x <- function() {
    
    # set current batch profile
    if (shuffle) {

      set.seed(seed)

      y_rows <- sample(i[partition]:j[partition])

    } else {

      y_rows <- c(i[partition]:j[partition])

    }
    
    x_rows <- y_rows - lookback
    
    rows <- c(min(x_rows):max(y_rows))
    
    n <- length(y_rows)
    
    # get current batch
    batch <- slice(data, rows)

    if (exists("rec")) batch <- bake(rec, batch)

    if (output %in% c("x", "all")) {
      
      for (k in c(1:max(x_rows)))

      batch_x <- select(batch, !!!x_select)

      x_array <- array(0, c(n, timesteps, x_length))
      
      x_indices <- seq(x_rows[k] - timesteps + 1, x_rows[k])

      x_array[k, , ] <- data.matrix(batch_x[x_indices, ])

    }

    if (output %in% c("y", "all")) {

      batch_y <- select(batch, !!!y_select)

      y_array <- array(0, c(n, y_length))

      y_array[, ] <- data.matrix(batch_y[y_rows, ])

    }
    
    # update iteration
    if (partition + 1 > steps_to_all) partition <<- 1

    else partition <<- partition + 1

    # resolving output
    if (output == "x") list(x_array)

    else if (output == "y") list(y_array)

    else list(x_array, y_array)

  }
  
  # return the generator
  structure(x, class = c("kg_ts", "function"))
  
}

# build series generator environment -------------------------------------------

#' @export

build_generator_env.kg_ts <- function(x) {

  if (is.null(x$x_select) & is.null(x$y_select))

    stop("select either x or y first")
    
  # set x and y profile
  if (!is.null(x$x_select)) {

    x$x_names <- colnames(x$preview$x)
    
    x$x_length <- length(x$x_names)
    
    x$input_shape <- x$x_length
    
  }
    
  if (!is.null(x$y_select)) {

    x$y_names <- colnames(x$preview$y)
    
    x$y_length <- length(x$y_names)
    
    x$output_shape <- x$y_length
    
  }
  
  # remove unused preview data
  x$preview <- NULL

  # set output profile
  if (is.null(x$x_select)) x$output <- "y"

  else if (is.null(x$y_select)) x$output <- "x"

  else x$output <- "all"
    
  x

}
