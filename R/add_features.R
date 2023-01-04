#' Add articulatory features for data frame based on column of X-SAMPA characters
#'
#' @param data A data frame with an existing column of X-SAMPA characters
#' @param col A string containing the name of the column with X-SAMPA characters in `data`
#' @param feature Òne or more strings containing the features to be added
#' @param lookup A data frame containing a lookup table with feature values. `lookup` is optional;
#' if left blank, a lookup table will be generated using `update_lookup`
#'
#' @return A data frame identical to `data` but with columns added for the specified feature(s)
#' @export
#'
#' @examples
#'x <- data.frame(x=1:8, y=c('p', 'p_h', 'd', 't', 't_h', 't:', 't:_>', 't:_}'))
#'print(x)
#'y <- add_features(data=x, col='y', feature=c('place', 'lar', 'release', 'length'))
#'print(y)
add_features <- function(data, col, feature, lookup=NULL) {

  if (!(is.null(lookup))) {
    tmp <- lookup
  } else {
    tmp <- update_lookup()
  }

  chars <- unique(data[,col])

  for (c in chars) {
    for (f in feature) {
      data[data[col]==c,f] <- feature_lookup(c, f, tmp)
    }
  }

  return(data)
}
