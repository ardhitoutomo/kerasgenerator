#' @export

add_recipe <- function(x, rec) {
  
  x$rec <- rec
  
  x <- .update_meta(x)
  
  x

}
