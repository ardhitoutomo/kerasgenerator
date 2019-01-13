#' @export

build_generator <- function(x) UseMethod("build_generator")

#' @export

build_generator.cross_section <- function(x) {

  list2env(build_generator_meta(x), environment())
  
  rm(x)

  function(...) {
    
    opts <- list(...)

    if (!is.null(opts$to)) {

      partition <<- opts$to

      return(paste("reset the generator to batch:", opts$to))

    }

    if (shuffle) {

      set.seed(seed)

      rows <- sample(i[partition]:j[partition])

    } else {

      rows <- c(i[partition]:j[partition])

    }

    batch <- data[rows, ]

    if (!is.null(rec)) batch <- bake(rec, batch)

    if (output %in% c("x", "all")) {

      batch_x <- select(batch, !!!x_select)

      x_array <- array(0, c(nrow(batch_x), ncol(batch_x)))

      x_array[, ] <- data.matrix(batch_x)

    }

    if (output %in% c("y", "all")) {

      batch_y <- select(batch, !!!y_select)

      y_array <- array(0, c(nrow(batch_y), ncol(batch_y)))

      y_array[, ] <- data.matrix(batch_y)

    }

    if (partition + 1 > steps_to_all) partition <<- 1

    else partition <<- partition + 1

    if (output == "x") list(x_array)

    else if (output == "y") list(y_array)

    else list(x_array, y_array)

  }

}

#' @export

build_generator_meta <- function(x) UseMethod("build_generator_meta")

#' @export

build_generator_meta.cross_section <- function(x) {

  if (is.null(x$x_select) & is.null(x$y_select))

    stop("select either x or y first")

  if (is.null(x$x_select)) x$output <- "y"

  else if (is.null(x$y_select)) x$output <- "x"

  else x$output <- "all"

  x$x_names <- colnames(x$preview$x)

  x$y_names <- colnames(x$preview$y)

  x

}

# # update generator meta
# fname <- deparse(sys.call()[[1]])
# parent <- parent.frame()
# attr(parent[[fname]], "batch_nth") <- batch_nth
