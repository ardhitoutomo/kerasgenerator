enclose <- function(..., sep = "/", enc = "[") {
  
  strings <- c(...)
  
  if (enc == "[")
  
    paste0("[", paste0(strings, collapse = sep), "]")
  
  else if (enc == "(")
  
    paste0("(", paste0(strings, collapse = sep), ")")
  
  else if (enc == "<")
  
    paste0("<", paste0(strings, collapse = sep), ">")
    
  else
  
    paste0(strings, collapse = sep)
  
}
