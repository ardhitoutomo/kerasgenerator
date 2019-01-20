# generator utilities ----------------------------------------------------------

#' @title Reset a generator into a specific partition
#'
#' @description A helper function to reset the generator current partition
#'
#' @param x A keras generator object
#' @param to The number of specific batch partition to be set. Default to the
#'  first partition
#'
#' @return An updated keras generator object
#'
#' @export

reset_generator <- function(gen, to = 1) {
  
  # update partition value
  assign("partition", to, envir = environment(gen))
  
}

#' @title Get a meta data from a generator
#'
#' @description A helper function to get a specific meta data from generator
#'  environment
#'
#' @param x A keras generator object
#' @param meta A specific meta data inside the generator
#'
#' @return The specified meta data object
#'
#' @export

get_meta <- function(gen, meta) {

  # get selected meta data
  get(meta, environment(gen))
  
}

#' @title Get a sample batch from a generator
#'
#' @description A helper function to get a sample batch in the form of keras
#'  array(s)
#'
#' @param x A keras generator object
#' @param n The number of specific batch partition to get. Default to the
#'  first partition
#'
#' @return A batch of keras array(s)
#'
#' @export

get_batch <- function(gen, n = 1) {
  
  # get current partition
  initial <- get_meta(gen, "partition")
  
  # set defined partition
  assign("partition", n, envir = environment(gen))
  
  # get the batch
  x <- gen()
  
  # revert back the partition value
  assign("partition", initial, envir = environment(gen))
  
  x
  
}
