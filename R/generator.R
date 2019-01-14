#' @export

data_generator <- function(data, batch_size = 32,
                           shuffle = TRUE, seed = 1) {
  
  data <- .as_generator_input(data)

  x <- as.list(environment())
  
  class(x) <- c("keras_generator", "data_generator")
  
  x <- .set_meta(x)
  
  x
  
}

#' @export

build_generator <- function(x) UseMethod("build_generator")

#' @export

build_generator.data_generator <- function(x) {

  list2env(.build_generator_env(x), environment())
  
  rm(x)

  x <- function() {
    
    if (shuffle) {

      set.seed(seed)

      rows <- sample(i[partition]:j[partition])

    } else {

      rows <- c(i[partition]:j[partition])

    }
    
    n <- length(rows)

    batch <- data[rows, ]

    if (exists("rec")) batch <- bake(rec, batch)

    if (output %in% c("x", "all")) {

      batch_x <- select(batch, !!!x_select)

      x_array <- array(0, c(n, x_length))

      x_array[, ] <- data.matrix(batch_x)

    }

    if (output %in% c("y", "all")) {

      batch_y <- select(batch, !!!y_select)

      y_array <- array(0, c(n, y_length))

      y_array[, ] <- data.matrix(batch_y)

    }
    
    if (partition + 1 > steps_to_all) partition <<- 1

    else partition <<- partition + 1

    if (output == "x") list(x_array)

    else if (output == "y") list(y_array)

    else list(x_array, y_array)

  }
  
  class(x) <- c("data_generator", "function")
  
  x

}

#' @export

.build_generator_env <- function(x) UseMethod(".build_generator_env")

#' @export

.build_generator_env.data_generator <- function(x) {

  if (is.null(x$x_select) & is.null(x$y_select))

    stop("select either x or y first")

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
  
  x$preview <- NULL

  if (is.null(x$x_select)) x$output <- "y"

  else if (is.null(x$y_select)) x$output <- "x"

  else x$output <- "all"
    
  x

}
