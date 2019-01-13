#' @export

.enclose <- function(..., sep = "/", enclose = "[") {
  
  strings <- c(...)
  
  if (enclose == "[")
  
    paste0("[", paste0(strings, collapse = sep), "]")
  
}
