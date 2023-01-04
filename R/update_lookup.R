#' Create feature lookup table
#'
#' `update_lookup` creates a lookup table with generic articulatory features
#' for standard X-SAMPA characters.
#'
#' @return A data frame containing a feature lookup table.
#' @seealso [feature_assign()] which is used to assign features to unknown
#' characters; [feature_reassign()] which is used to change the generic feature
#' values provided by [update_lookup()]; [feature_lookup()] which is used under
#' the hood to look up feature values; [add_features()] which is used to add
#' feature column(s) to a data frame.
#' @export
#'
#' @examples
#' x <- update_lookup()
#' head(x)
update_lookup <- function() {

  tmp <- sampa_lookup

  tmp[,'length'] <- 'short'
  tmp[,'modifications'] <- NA
  tmp[,'syllabic'] <- dplyr::case_when(
    tmp[,'manner'] == 'vowel' ~ 'yes',
    TRUE ~ 'no')
  tmp[,'release'] <- dplyr::case_when(
    tmp[,'major_manner'] == 'obstruent' ~ 'released',
    TRUE ~ 'NA')
  tmp[,'nasalization'] <- dplyr::case_when(
    tmp[,'manner'] == 'nasal' ~ 'yes',
    TRUE ~ 'no')
  tmp[,'tone'] <- NA

  return(tmp)

}
