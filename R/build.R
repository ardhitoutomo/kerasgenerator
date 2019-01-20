# build_generator generics -----------------------------------------------------

#' @title Compile a keras generator meta into fully functional generator
#'
#' @param x A keras generator meta
#'
#' @return A fully functional keras generator object
#'
#' @name build
#' @rdname build
#'
#' @export

build_generator <- function(x, ...) UseMethod("build_generator")

#' @keywords internal
#' @export

build_generator_env <- function(x) UseMethod("build_generator_env")
