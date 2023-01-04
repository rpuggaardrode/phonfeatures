#' Look up articulatory features
#'
#' Given a phonetic character, `feature_lookup()` can be used to return one or
#' more articulatory feature values. `feature_lookup()` can be used to check
#' whether the generic feature values provided by [update_lookup()] are in
#' agreement with the user's needs, and the function is used under the hood for
#' the [add_features()] function.
#'
#' @param sampa A string containing a phonetic character.
#' @param feature One or more strings specifying the features to look up;
#' if left blank, all pre-specified feature are returned.
#' @param lookup A data frame containing a lookup table with feature values.
#' `lookup` is optional; if left blank, a lookup table will be generated using
#' [update_lookup()].
#' @param ipa A Boolean indicating whether the phonetic characters in `col` are
#' IPA characters. Default is `FALSE`.
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
#' feature_lookup(sampa='p_h')
#' feature_lookup(sampa='p_h', feature='place')
#' x <- feature_reassign(sampa='t', feature='place', val='dental')
#' feature_lookup(sampa='t', feature='place', lookup=x)
#' ###
#' feature_lookup(sampa='2', feature='roundness')
#' feature_lookup(sampa='ø', feature='roundness', ipa=TRUE)
feature_lookup <- function (sampa,
                            feature=c('height', 'backness', 'roundness',
                                      'place', 'major_place', 'manner',
                                      'major_manner', 'lar', 'voice', 'length',
                                      'modifications', 'syllabic', 'release',
                                      'nasalization', 'tone'),
                            lookup=NULL,
                            ipa=FALSE) {

  if (ipa) {sampa <- ipa::ipa(sampa)}
  sampa <- stringr::str_replace(sampa, '\\\\', '/')

  if (!(is.null(lookup))) {
    tmp <- lookup
  } else {
    tmp <- update_lookup()
  }

  extra_mod <- (c(':', '`'))
  if (any(stringr::str_detect(sampa, extra_mod)) && !(sampa %in% tmp[,1])) {
    sampa <- stringr::str_replace(sampa, ':', '_:')
    sampa <- stringr::str_replace(sampa, '`', '_`')
  }

  split <- unlist(stringr::str_split(sampa, '_'))
  sim <- split[1]
  mod <- split[2:length(split)]

  legal_mod <- sampa_lookup_mod$mod

  if (any(is.na(mod))) {

    if (!(sampa %in% tmp[,1])) {
      stop(paste0('I am unfamiliar with ', sampa,
                  '\n Definitions for unknown characters can be added with the feature_assign() function.'))
    } else {
      r <- which(tmp[,1] == sampa)
      return(tmp[r, feature])
    }

  } else if(!(sim %in% tmp[,1])) {
    stop(paste0('I am unfamiliar with ', sampa,
                '\n Definitions for unknown characters can be added with the feature_assign() function.'))
  } else if(!any(mod %in% legal_mod)) {
    stop(paste0('I am unfamiliar with one or more of the modifications in ', sampa,
                '\n I am familiar with the following modifications: ', list(legal_mod),
                '\n Definitions for unknown characters can be added with the feature_assign() function.'))

  } else {

    f <- sampa_lookup_mod$feature
    v <- sampa_lookup_mod$val
    tmp <- feature_assign(sampa, copy=sim, lookup=tmp)

    for(m in mod){
      mr <- which(legal_mod == m)
      tmp <- feature_reassign(sampa, f[mr], v[mr], tmp)
    }

    i <- nrow(tmp)
    return(tmp[i, feature])

  }
}
