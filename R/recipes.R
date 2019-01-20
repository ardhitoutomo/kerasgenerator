# inject recipes obj -----------------------------------------------------------

#' @title Inject `recipes` object for preprocessing on the fly
#'
#' @family injection
#'
#' @param x A keras generator object
#' @param rec A prepared `recipes` object
#'
#' @return An updated keras generator object
#'
#' @export

inject_recipe <- function(x, rec) {
  
  # store recipe
  x$rec <- rec
  
  # update meta
  set_meta(x)

}
