#' @export

reset_generator <- function(gen, to = 1) {
  
  assign("partition", to, envir = environment(gen))
  
}
