#' @export

.enclose <- function(..., sep = "/", enc = "[") {
  
  strings <- c(...)
  
  if (enc == "[")
  
    paste0("[", paste0(strings, collapse = sep), "]")
  
  if (enc == "(")
  
    paste0("(", paste0(strings, collapse = sep), ")")
  
  if (enc == "<")
  
    paste0("<", paste0(strings, collapse = sep), ">")
  
}
