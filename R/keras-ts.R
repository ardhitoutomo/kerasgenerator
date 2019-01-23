# forecast generator -----------------------------------------------------------

#' @export

forecast_generator <- function(object, generator, ...,
                               horizon, label = "none") {
                                 
  # stop if
  if (horizon > get_meta(generator, "lookback"))
    
    stop("horizon must not exceed lookback value")

  # wrap-up
  x <- c(list(object = object, generator = generator), list(...))

  # get generator meta
  meta <- as.list(environment(x$generator))
  
  # remove unused
  meta$x <- NULL
  
  # attach forecast params
  meta$horizon <- horizon
  
  # build forecast generator
  x$generator <- build_generator(structure(meta, class = "kg_fc"))
  
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
    
  }
  
  else if (label == "none") {
    
    pred
    
  }
  
}
