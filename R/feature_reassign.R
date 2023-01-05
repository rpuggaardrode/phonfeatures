#' Change feature values for X-SAMPA character
#'
#' `feature_reassign()` is used to create a new feature lookup table for X-SAMPA
#' characters if the user wishes to assign different (non-standard) feature
#' values to existing characters.
#'
#' @details Note that reassigned features will be inherited by any characters
#' with diacritics. For example, if the character `t` is assigned the place
#' feature `dental`, then `t_h` will also be assigned the place feature
#' `dental`. If you need to override this, `t_h` can be assigned manually using
#' [feature_assign()].
#'
#' `sampa` can take either a string or multiple strings, if the same feature
#' needs to be changed for multiple characters. See example below.
#'
#' `feature_reassign()` does not explicitly support IPA
#' characters. However, if `feature_reassign()` is used on an X-SAMPA string
#' corresponding to the IPA string you wish to modify, [add_features()] with
#' `ipa=TRUE` should still give the desired result (see the last example).
#'
#' @param sampa One or more strings containing existing X-SAMPA characters to be modified.
#' @param feature One or more strings specifying the features to be changed.
#' The features for which generic features are provided are:
#' * `height` vowel height
#' * `backness` vowel backness
#' * `roundness` vowel roundness
#' * `place` consonant place of articulation
#' * `major_place` major place features (coronal, dorsal, etc.)
#' * `manner` manner of articulation
#' * `major_manner` major manner features (obstruent, sonorant)
#' * `lar` laryngeal features
#' * `voice` binary voicing feature
#' * `length`
#' * `modifications` associated with diacritics, such as `velarized`, `palatalized`, etc.
#' * `syllabic`
#' * `release` modifying diacritics for (mostly) stop releases
#' * `nasalization`
#' * `tone`
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
#' x <- feature_reassign(sampa='t', feature=c('lar','place'),
#'                       val=c('aspirated','dental'))
#' x[x$segm=='t',]
#' y <- feature_reassign(sampa='d', feature='place', val='dental', lookup=x)
#' y[y$segm=='d',]
#' ### Alternatively,
#' x <- feature_reassign(sampa=c('d', 't'), feature='place', val='dental')
#' ###
#' feature_lookup(phon='d', feature='place', lookup=x, ipa=TRUE)
feature_reassign <- function(sampa,
                             feature=NA,
                             val=NA,
                             lookup=NULL){

  sampa <- stringr::str_replace(sampa, '\\\\', '/')

  if (!(is.null(lookup))) {
    tmp <- lookup
  } else {
    tmp <- update_lookup()
  }

  r <- c()
  for (i in sampa) {
    r[i] <- which(tmp[,1] == i)
  }
  r <- unname(r)

  if (length(r)==0) {
    stop(paste0(sampa, ' does not exist in the lookup table'))
  }

  if (any(!is.na(feature)) && any(!is.na(val))) {
    tmp[r,feature] <- val
  }

  return(tmp)

}
