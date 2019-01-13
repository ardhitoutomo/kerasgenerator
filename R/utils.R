#' @export

# reset generator
reset_generator <- function(generator, to, n) {
  
  # force reset
  if (!missing(to)) generator(to = to)
  if (!missing(n)) generator(n = n)
  
}
