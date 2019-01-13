#' @export

.as_generator_input <- function(x) UseMethod(".as_generator_input")

#' @export

.as_generator_input.data.frame <- function(x) as_tibble(x)

#' @export

.as_generator_input.default <- function(x) stop("unsupported input")
