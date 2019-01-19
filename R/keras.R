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

predict_generator.data_generator <- function(object, generator,
                                             ..., tidy_output = TRUE) {
  
  x <- c(as.list(environment()), list(...))
  
  tidy_output <- x$tidy_output
  x$tidy_output <- NULL
  
  assign("output", "x", envir = environment(x$generator))
  
  x$steps <- get_meta(x$generator, "steps_to_all")
  
  pred <- do.call(keras::predict_generator, x)
  
  if (tidy_output) {
    
    pred <- as.data.frame(pred)
    
    colnames(pred) <- get_meta(x$generator, "y_names")
    
    pred <- as_tibble(pred)
    
    if (exists("rec", envir = environment(train_gen))) {
      
      rec <- get_meta(x$generator, "rec")
      
      var_info <- rec$var_info

      orig_y <- which(var_info$role == "outcome" & var_info$type == "nominal")

      y_prefix <- paste0(var_info[orig_y, "variable"], "_")

      patterns <- c(rep("", length(y_prefix)))

      names(patterns) <- y_prefix

      colnames(pred) <- str_replace_all(colnames(pred), patterns)
      
    }
            
    pred_class <- mutate(pred, obs = seq(1, nrow(pred)))
    pred_class <- gather(pred_class, class, prob, -obs)
    pred_class <- group_by(pred_class, obs)
    pred_class <- filter(pred_class, prob == max(prob))
    pred_class <- ungroup(pred_class)
    
    mutate(pred, class = factor(pred_class$class, levels = colnames(pred)))
    
  } else {
    
    pred
    
  }

}
