#' Look up articulatory features for X-SAMPA character
#'
#' @param sampa A string containing an X-SAMPA character
#' @param feature One or more strings specifying the features to look up;
#' if left blank, all pre-specified feature are returned.
#' @param lookup A data frame containing a lookup table with feature values. `lookup` is optional;
#' if left blank, a lookup table will be generated using `update_lookup`
#'
#' @return A character object or data frame containing the requested feature(s)
#' @export
#'
#' @examples
#' feature_lookup(sampa='p_h')
#' feature_lookup(sampa='p_h', feature='place')
#' x <- feature_reassign(sampa='t', feature='place', val='dental')
#' feature_lookup(sampa='t', feature='place', lookup=x)
feature_lookup <- function (sampa, feature=c('height', 'backness', 'roundness',
                                             'place', 'major_place', 'manner',
                                             'major_manner', 'lar', 'voice', 'length',
                                             'modifications', 'syllabic', 'release',
                                             'nasalization', 'tone'), lookup=NULL) {

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
