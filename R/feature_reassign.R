#' Change feature values for X-SAMPA character
#'
#' @param sampa One or more strings containing existing X-SAMPA characters to be modified
#' @param feature One or more strings specifying the features to be changed
#' @param val One or more strings specifying the values to be associated with the `feature`s
#' @param lookup A data frame containing a lookup table with feature values. `lookup` is optional;
#' if left blank, a lookup table will be generated using `update_lookup`
#'
#' @return A data frame containing a feature lookup table
#' @export
#'
#' @examples
#' lkup <- update_lookup()
#' lkup[lkup$segm=='t'|lkup$segm=='d',]
#' x <- feature_reassign(sampa='t', feature='place', val='dental')
#' x[x$segm=='t',]
#' y <- feature_reassign(sampa='d', feature='place', val='dental', lookup=x)
#' y[y$segm=='d',]
#' # Alternatively,
#' z <- feature_reassign(sampa=c('d','t'), feature='place', val='dental')
#' z[z$segm=='t'|z$segm=='d',]
feature_reassign <- function(sampa, feature=NA, val=NA, lookup=NULL){

  if (!(is.null(lookup))) {
    tmp <- lookup
  } else {
    tmp <- update_lookup()
  }

  r <- which(tmp[,1] == sampa)

  if (length(r)==0) {
    stop(paste0(sampa, ' does not exist in the lookup table'))
  }

  if (!is.na(feature) && !is.na(val)) {
    tmp[r,feature] <- val
  }

  return(tmp)

}
