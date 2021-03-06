##' Exclude months from analysis
##' 
##' Single months or ranges of months can be excluded from
##' analysis. This is helpful for e.g. excluding winter months without
##' cambial activity.
##' @details These convenience function is provided for the exclusion
##'   of months. E.g., \code{.range(exclude_from(-6:10, -11:3))} will
##'   yield the monthly values of all parameters for the months
##'   previous June (-6) to current October (10), but without the
##'   months previous November (-11) to current March (3) in
##'   between. While it is also possible to supply arbitrary vectors
##'   as month specification, and not only ranges as shown in most of
##'   the examples here, this way of excluding e.g. the dormant season
##'   is far more convenient.
##' @param month range of numeric month ids
##' @param exclude range or set of months to exclude
##' @return a reduced set of numeric month ids
##' @keywords manip
##' @examples
##' exfr(-5:10, -10:3)
##' @seealso \code{link{.range}}, \code{link{.mean}},
##' \code{link{.sum}}
##' @export
exclude_from <- function(month, exclude = NULL) {
  ## check if exclude is given
  if (is.null(exclude))
    return(month)
  
  ## month must first be supplied as a range!
  if (!is_continuous(month)) {
    stop("`month` has to be a continuous range.")
  }
  month <- correct_continuous(month)
  
  ## check if exclude is supplied as a range
  correct_exclude <- function(exclude) {
    if (is_continuous(exclude)) {
      exclude <- correct_continuous(exclude)
    } else {
      if (any(exclude == 0)) {
        stop("It is not possible to mix ranges through zero with other specifications.")
      }
    }
    exclude
  }
  
  ## do exclusion
  do_exclude <- function(month, exclude) {
    matching <- na.omit(match(exclude, month))
    if (length(matching) > 0) {
      month <- month[-na.omit(matching)]
    }
    month
  }

  if (is.list(exclude)) {
    n <- length(exclude)
    for (i in 1:n) {
      .exclude <- correct_exclude(exclude[[i]])
       month <- do_exclude(month, .exclude)
    }
  } else {
    .exclude <- correct_exclude(exclude)
    month <- do_exclude(month, .exclude)
  }
  month
}

## (aliased for convenience)

##' @rdname exclude_from
##' @export
exfr <- exclude_from
