#' Look up articulatory features
#'
#' Given a phonetic character, `feature_lookup()` can be used to return one or
#' more articulatory feature values. `feature_lookup()` can be used to check
#' whether the generic feature values provided by [update_lookup()] are in
#' agreement with the user's needs, and the function is used under the hood for
#' the [add_features()] function.
#'
#' @param phon A string containing a phonetic character.
#' @param feature One or more strings specifying the features to look up;
#' if left blank, all pre-specified feature are returned. These are:
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
#' @param lookup A data frame containing a lookup table with feature values.
#' `lookup` is optional; if left blank, a generic lookup table will be generated
#' using [update_lookup()]. Updated lookup tables can be generated with
#' [feature_reassign()] if different feature values are needed and
#' [feature_assign()] unknown characters are needed.
#' @param ipa A Boolean.
#' * `FALSE` (default) The phonetic characters in `col` are X-SAMPA.
#' * `TRUE` The phonetic characters in `col` are IPA.
#'
#' @return A character object or data frame containing the requested feature(s)
#' @seealso [update_lookup()] which generates a generic feature lookup table if
#' no other lookup table is provided; [feature_assign()] which is used to
#' assign features to unknown characters; [feature_reassign()] which is used
#' to change the generic feature values provided by [update_lookup()];
#' [add_features()] which is used to add feature column(s) to a data frame.
#'
#' [ipa::ipa()] is used to convert X-SAMPA characters into IPA characters if
#' `ipa=TRUE`.
#' @export
#'
#' @examples
#' feature_lookup(phon='p_h')
#' feature_lookup(phon='p_h', feature='place')
#' x <- feature_reassign(sampa='t', feature='place', val='dental')
#' feature_lookup(phon='t', feature='place', lookup=x)
#' ###
#' feature_lookup(phon='2', feature='roundness')
#' feature_lookup(phon='ø', feature='roundness', ipa=TRUE)
feature_lookup <- function (phon,
                            feature=c('height', 'backness', 'roundness',
                                      'place', 'major_place', 'manner',
                                      'major_manner', 'lar', 'voice', 'length',
                                      'modifications', 'syllabic', 'release',
                                      'nasalization', 'tone'),
                            lookup=NULL,
                            ipa=FALSE) {

  if (ipa) {phon <- ipa::ipa(phon)}
  phon <- stringr::str_replace(phon, '\\\\', '/')

  if (!(is.null(lookup))) {
    tmp <- lookup
  } else {
    tmp <- update_lookup()
  }

  extra_mod <- (c(':', '`'))
  if (any(stringr::str_detect(phon, extra_mod)) && !(phon %in% tmp[,1])) {
    phon <- stringr::str_replace(phon, ':', '_:')
    phon <- stringr::str_replace(phon, '`', '_`')
  }

  split <- unlist(stringr::str_split(phon, '_'))
  sim <- split[1]
  mod <- split[2:length(split)]

  legal_mod <- sampa_lookup_mod$mod

  if (any(is.na(mod))) {

    if (!(phon %in% tmp[,1])) {
      stop(paste0('I am unfamiliar with ', phon,
                  '\n Definitions for unknown characters can be added with the feature_assign() function.'))
    } else {
      r <- which(tmp[,1] == phon)
      return(tmp[r, feature])
    }

  } else if(!(sim %in% tmp[,1])) {
    stop(paste0('I am unfamiliar with ', phon,
                '\n Definitions for unknown characters can be added with the feature_assign() function.'))
  } else if(!any(mod %in% legal_mod)) {
    stop(paste0('I am unfamiliar with one or more of the modifications in ', phon,
                '\n I am familiar with the following modifications: ', list(legal_mod),
                '\n Definitions for unknown characters can be added with the feature_assign() function.'))

  } else {

    f <- sampa_lookup_mod$feature
    v <- sampa_lookup_mod$val
    tmp <- feature_assign(phon, copy=sim, lookup=tmp)

    for(m in mod){
      mr <- which(legal_mod == m)
      tmp <- feature_reassign(phon, f[mr], v[mr], tmp)
    }

    i <- nrow(tmp)
    return(tmp[i, feature])

  }
}
