#' Change feature values for X-SAMPA character
#'
#' `feature_reassign()` is used to create a new feature lookup table for X-SAMPA
#' characters if the user wishes to assign different (non-standard) feature
#' values to existing characters.
#'
#' @param sampa String containing existing X-SAMPA characters to be modified.
#' @param feature One or more strings specifying the features to be changed.
#' @param val One or more strings specifying the values to be associated with
#' the `feature`s.
#' @param lookup A data frame containing a lookup table with feature values.
#' `lookup` is optional; if left blank, a lookup table will be generated using
#' [update_lookup()].
#'
#' @return A data frame containing a feature lookup table.
#' @seealso [update_lookup()] which generates a generic feature lookup table if
#' no other lookup table is provided; [feature_assign()] which is used to
#' assign features to unknown characters; [feature_lookup()] which is used under
#' the hood to look up feature values. [add_features()] which is used to add
#' feature column(s) to a data frame.
#' @export
#'
#' @examples
#' lkup <- update_lookup()
#' lkup[lkup$segm=='t'|lkup$segm=='d',]
#' x <- feature_reassign(sampa='t', feature='place', val='dental')
#' x[x$segm=='t',]
#' y <- feature_reassign(sampa='d', feature='place', val='dental', lookup=x)
#' y[y$segm=='d',]
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
