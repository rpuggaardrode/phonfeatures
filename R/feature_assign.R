#' Assign features to X-SAMPA character
#'
#' `feature_assign()` is used to create a new feature lookup table with
#' added unknown X-SAMPA characters.
#'
#' @details Note that features assigned to new characters will be inherited by
#' versions of that character with diacritics. For example, if the character
#' `ph` is copied from `p` with the value `aspirated` for the feature `lar`,
#' then passing `ph_G` to [feature_lookup()] will return a velarized aspirated
#' stop (see the final example below). If you need to override this, `ph_G` must
#' be manually assigned features.
#'
#' `feature_reassign()` does not presently support IPA
#' characters. The function [ipa::ipa()] is used under the hood to convert IPA
#' characters to X-SAMPA, and if you are using characters that are not known
#' to [ipa::ipa()], the functionality in this package will fail.
#'
#' @param new A string containing the character to be added to the X-SAMPA
#' lookup table.
#' @param feature One or more strings specifying the features to be associated
#' with `new`.
#' The features for which generic features are provided are:
#' * `height` vowel height
#' * `backness` vowel backness
#' * `roundness` vowel roundness
#' * `place` consonant place of articulation
#' * `major place` major place features (coronal, dorsal, etc.)
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
#' @param copy A string containing an existing character in the lookup table from
#' which other features are copied.
#' @param lookup A data frame containing a lookup table with feature values.
#' `lookup` is optional; if left blank, a lookup table will be generated using
#' [update_lookup()].
#'
#' @return A data frame containing a feature lookup table.
#' @seealso [update_lookup()] which generates a generic feature lookup table if
#' no other lookup table is provided; [feature_lookup()] which is used under
#' the hood to look up feature values; [feature_reassign()] which is used
#' to change the generic feature values provided by [update_lookup()];
#' [add_features()] which is used to add feature column(s) to a data frame.
#' @export
#'
#' @examples
#' x <- feature_assign(new='ph', feature='lar', val='aspirated', copy='p')
#' tail(x)
#' y <- feature_assign(new='th', feature=c('lar', 'place'),
#'                     val=c('aspirated', 'dental'), copy='t', lookup=x)
#' tail(y)
#' ### If copy is left blank, NA's will be generated for unspecified features
#' z <- feature_assign(new='ph', feature='lar', val='aspirated')
#' tail(z)
#' ###
#' feature_lookup(phon='ph_G', feature=c('lar', 'modifications'), lookup=x)
feature_assign <- function(new,
                           feature=NA,
                           val=NA,
                           copy=NA,
                           lookup=NULL){

  new <- stringr::str_replace(new, '\\\\', '/')

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

  if (any(!is.na(feature)) && any(!is.na(val))) {
    tmp[i+1,feature] <- val
  }

  return(tmp)

}
