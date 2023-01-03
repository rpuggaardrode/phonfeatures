#' Create feature lookup table with generic features
#'
#' @return A data frame containing a feature lookup table
#' @export
#'
#' @examples
#' x <- update_lookup()
update_lookup <- function() {

  tmp <- sampa_lookup

  tmp[,'length'] <- 'short'
  tmp[,'modifications'] <- NA
  tmp[,'syllabic'] = dplyr::case_when(
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
