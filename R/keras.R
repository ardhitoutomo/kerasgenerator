#' @importFrom keras fit_generator
#' @export

fit_generator <- function(object, generator, ...) {
  
  UseMethod("fit_generator", generator)

}

#' @export

fit_generator.default <- keras::fit_generator

#' @export

fit_generator.kg_xs <- function(object, generator, ...) {
  
  # wrap-up
  x <- c(as.list(environment()), list(...))
  
  # ensure from first partition
  reset_generator(x$gen)
  
  # handle steps
  if (is.null(x$steps_per_epoch))
  
    x$steps_per_epoch <- get_meta(x$generator, "steps_to_all")
  
  if (!is.null(x$validation_data) & is.null(x$validation_steps))
  
    x$validation_steps <- get_meta(x$validation_data, "steps_to_all")
    
  # call fit_generator
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

evaluate_generator.kg_xs <- function(object, generator, ...) {
  
  # wrap-up
  x <- c(as.list(environment()), list(...))
  
  # ensure from first partition
  reset_generator(x$gen)

  # handle steps
  if (is.null(x$steps))
    
    x$steps <- get_meta(x$generator, "steps_to_all")
  
  # call evaluate_generator
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

predict_generator.kg_xs <- function(object, generator,
                                             ..., label = "single") {
  
  # wrap-up
  x <- c(as.list(environment()), list(...))
  
  # remove unused
  x$label <- NULL
  
  # ensure from first partition
  reset_generator(x$gen)

  # set output to only x
  assign("output", "x", envir = environment(x$generator))
  
  # handle steps
  if (is.null(x$steps))
    
    x$steps <- get_meta(x$generator, "steps_to_all")
  
  # call predict_generator
  pred <- do.call(keras::predict_generator, x)
  
  # tidy-up
  pred <- as.data.frame(pred)
  
  colnames(pred) <- get_meta(x$generator, "y_names")
  
  pred <- as_tibble(pred)
  
  # handle dummy
  if (exists("rec", envir = environment(train_gen))) {
    
    rec <- get_meta(x$generator, "rec")
    
    var_info <- rec$var_info

    y_orig <- which(var_info$role == "outcome" & var_info$type == "nominal")

    if (!length(y_orig) == 0) {
      
      y_prefix <- paste0(var_info[y_orig, "variable"], "_")

      patterns <- c(rep("", length(y_prefix)))

      names(patterns) <- y_prefix

      colnames(pred) <- str_replace_all(colnames(pred), patterns)
      
    }
    
  }
  
  # handle label output
  if (label == "single") {
                
    pred_label <- mutate(pred, obs = seq(1, nrow(pred)))
    pred_label <- gather(pred_label, label, prob, -obs)
    pred_label <- group_by(pred_label, obs)
    pred_label <- filter(pred_label, prob == max(prob))
    pred_label <- ungroup(pred_label)
    
    mutate(pred, label = factor(pred_label$label, levels = colnames(pred)))
    
  } else {
    
    pred
    
  }

}
