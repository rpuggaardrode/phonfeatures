#' Assign features to unknown X-SAMPA character
#'
#' @param new A string containing the character to be added to the X-SAMPA lookup table
#' @param feature One or more strings specifying the features to be associated with `new`
#' @param val One or more strings specifying the values to be associated with the `feature`s
#' @param copy A string containing an existing character in the lookup table for which other
#' features are copied
#' @param lookup A data frame containing a lookup table with feature values. `param` is optional;
#' if left blank, a lookup table will be generated using `update_lookup`
#'
#' @return A data frame
#' @export
#'
#' @examples
#' x <- feature_assign(new='ph', feature='lar', val='aspirated', copy='p')
#' tail(x)
#' y <- feature_assign(new='th', feature='lar', val='aspirated', copy='t', lookup=x)
#' tail(y)
feature_assign <- function(new, feature=NA, val=NA, copy=NA, lookup=NULL){

  if (!(is.null(lookup))) {
    tmp <- lookup
  } else {
    tmp <- update_lookup()
  }

  i <- nrow(tmp)

  if (!is.na(copy)) {

    r <- which(tmp[,1] == copy)

    if (length(r)==0) {
      stop(paste0(copy, ' does not exist in the lookup table'))
    }

    tmp[i+1,] <- tmp[r,]

  }

  tmp[i+1,'segm'] <- new

  if (!is.na(feature) && !is.na(val)) {
    tmp[i+1,feature] <- val
  }

  return(tmp)

}
