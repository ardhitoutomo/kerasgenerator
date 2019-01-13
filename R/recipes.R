#' @export

add_recipe <- function(x, rec) UseMethod("add_recipe")

#' @export

add_recipe.cross_section <- function(x, rec) {
  
  x$rec <- rec
  
  x <- .update_meta(x)
  
  x

}
