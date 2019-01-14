#' @importFrom keras fit_generator
#' @export

fit_generator <- function(object, generator, ...) {
  
  UseMethod("fit_generator", generator)

}

#' @export

fit_generator.default <- keras::fit_generator

#' @export

fit_generator.data_generator <- function(object, generator, ...) {
  
  x <- c(as.list(environment()), list(...))
  
  x$steps_per_epoch <- get_meta(x$generator, "steps_to_all")
  
  if (!is.null(x$validation_data))
  
    x$validation_steps <- get_meta(x$validation_data, "steps_to_all")
    
  do.call(keras::fit_generator, x)

}

#' @importFrom keras evaluate_generator
#' @export

evaluate_generator <- function(object, generator, ...) {
  
  UseMethod("evaluate_generator", generator)

}

#' @export

evaluate_generator.default <- keras::evaluate_generator

#' @export

evaluate_generator.data_generator <- function(object, generator, ...) {
  
  x <- c(as.list(environment()), list(...))
  
  x$steps <- get_meta(x$generator, "steps_to_all")
  
  do.call(keras::evaluate_generator, x)

}

#' @importFrom keras predict_generator
#' @export

predict_generator <- function(object, generator, ...) {
  
  UseMethod("predict_generator", generator)

}

#' @export

predict_generator.default <- keras::predict_generator

#' @export

predict_generator.data_generator <- function(object, generator, ...) {
  
  x <- c(as.list(environment()), list(...))
  
  assign("output", "x", envir = environment(x$generator))
  
  x$steps <- get_meta(x$generator, "steps_to_all")
  
  do.call(keras::predict_generator, x)

}
