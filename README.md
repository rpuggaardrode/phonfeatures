
<!-- README.md is generated from README.Rmd. Please edit that file -->

# phonfeatures

<!-- badges: start -->
<!-- badges: end -->

`phonfeatures` is an R package which allows the user to efficiently add
columns with articulatory features to existing data frames with phonetic
characters using the function `add_features()`.

The package provides several generic features for all regular IPA and
X-SAMPA characters as well as for most diacritics. These generic
features can be checked using the function `feature_lookup()`. The
package also provides functionality for changing the feature values of
known characters with `feature_reassign()`, and for introducing unknown
characters with `feature_assign()`.

## Installation

You can install the development version of `phonfeatures` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rpuggaardrode/phonfeatures")
```

## Usage

### Adding features to a data frame

The most common use case is when you have a data frame containing
transcriptions, and you want to convert those transcriptions into some
articulatory features. It could fx look like this:

``` r
library(phonfeatures)
head(test_data, 10)
#>    Identifier IntVocIntervals     tmin     tmax age Stop
#> 1           1               1 0.000000 0.245914  20    d
#> 2           2               2 0.245914 0.798165  20    k
#> 3           3               3 0.798165 1.103336  20    d
#> 4           4               4 1.103336 1.716694  20    k
#> 5           5               5 1.716694 2.206374  20    k
#> 6           6               6 2.206374 2.546418  20    g
#> 7           7               7 2.546418 2.844114  20    t
#> 8           8               8 2.844114 3.357136  20    k
#> 9           9               9 3.357136 3.962371  20    k
#> 10         10              10 3.962371 4.462383  20    k
```

Say you want to add columns to this data frame with information about
place of articulation and laryngeal features corresponding to the stop
column. You would proceed like this:

``` r
new_data <- add_features(data=test_data, col='Stop', feature=c('place', 'lar'))
head(new_data, 10)
#>    Identifier IntVocIntervals     tmin     tmax age Stop    place       lar
#> 1           1               1 0.000000 0.245914  20    d alveolar    voiced
#> 2           2               2 0.245914 0.798165  20    k    velar voiceless
#> 3           3               3 0.798165 1.103336  20    d alveolar    voiced
#> 4           4               4 1.103336 1.716694  20    k    velar voiceless
#> 5           5               5 1.716694 2.206374  20    k    velar voiceless
#> 6           6               6 2.206374 2.546418  20    g    velar    voiced
#> 7           7               7 2.546418 2.844114  20    t alveolar voiceless
#> 8           8               8 2.844114 3.357136  20    k    velar voiceless
#> 9           9               9 3.357136 3.962371  20    k    velar voiceless
#> 10         10              10 3.962371 4.462383  20    k    velar voiceless
```

### Checking feature values

You can use `?add_features` to see which features are generically
available, or use `feature_lookup()` to check all the features that are
generically assigned to a character:

``` r
feature_lookup(phon='g')
#>   height backness roundness place major_place manner major_manner    lar  voice
#> 8                           velar      dorsal   stop    obstruent voiced voiced
#>   length modifications syllabic  release nasalization tone
#> 8  short            NA       no released           no   NA
```

`feature_lookup()` can also be used to check specific feature values:

``` r
feature_lookup(phon='g', feature=c('lar', 'place'))
#>      lar place
#> 8 voiced velar
```

### Changing feature values

The generic features will not be suitable for all purposes. For example,
if (like me) you are interested in Danish stops, there’s a good chance
that you have been using /b d g p t k/ as a shorthand for sounds that
are *not* actually voiced and voiceless, but rather voiceless and
aspirated.

The package also provides functions for creating a new lookup table used
for checking feature values. We can update the value of `lar` for /b d
g/ with the function `feature_reassign()` and save it to a new data
frame `dan_lkup` like this:

``` r
dan_lkup <- feature_reassign(sampa=c('b', 'd', 'g'), 
                             feature='lar', val='voiceless')
```

And the values of /p t k/ can then be updated by running
`feature_reassign()` again, this time specifying that we’re using the
lookup table `dan_lkup`:

``` r
dan_lkup <- feature_reassign(sampa=c('p', 't', 'k'), 
                             feature='lar', val='aspirated',
                             lookup=dan_lkup)
```

We can now use `dan_lkup` to add features to our data frame, instead of
using the generic features:

``` r
new_data <- add_features(data=test_data, col='Stop', feature=c('place', 'lar'),
                         lookup=dan_lkup)
head(new_data, 10)
#>    Identifier IntVocIntervals     tmin     tmax age Stop    place       lar
#> 1           1               1 0.000000 0.245914  20    d alveolar voiceless
#> 2           2               2 0.245914 0.798165  20    k    velar aspirated
#> 3           3               3 0.798165 1.103336  20    d alveolar voiceless
#> 4           4               4 1.103336 1.716694  20    k    velar aspirated
#> 5           5               5 1.716694 2.206374  20    k    velar aspirated
#> 6           6               6 2.206374 2.546418  20    g    velar voiceless
#> 7           7               7 2.546418 2.844114  20    t alveolar aspirated
#> 8           8               8 2.844114 3.357136  20    k    velar aspirated
#> 9           9               9 3.357136 3.962371  20    k    velar aspirated
#> 10         10              10 3.962371 4.462383  20    k    velar aspirated
```

### IPA and X-SAMPA

You may have noticed that the phonetic character argument in
`feature_reassign()` is called `sampa`. This is because this function
only works with [X-SAMPA](https://en.wikipedia.org/wiki/X-SAMPA)
characters. `add_features()` and `feature_lookup()` also use X-SAMPA
characters by default, but these functions have an option to use IPA
instead, by setting `ipa=TRUE`. Let’s see what this does to the code we
just ran:

``` r
new_data <- add_features(data=test_data, col='Stop', feature=c('place', 'lar'),
                         lookup=dan_lkup, ipa=TRUE)
head(new_data, 10)
#>    Identifier IntVocIntervals     tmin     tmax age Stop    place       lar
#> 1           1               1 0.000000 0.245914  20    d alveolar voiceless
#> 2           2               2 0.245914 0.798165  20    k    velar aspirated
#> 3           3               3 0.798165 1.103336  20    d alveolar voiceless
#> 4           4               4 1.103336 1.716694  20    k    velar aspirated
#> 5           5               5 1.716694 2.206374  20    k    velar aspirated
#> 6           6               6 2.206374 2.546418  20    g    velar voiceless
#> 7           7               7 2.546418 2.844114  20    t alveolar aspirated
#> 8           8               8 2.844114 3.357136  20    k    velar aspirated
#> 9           9               9 3.357136 3.962371  20    k    velar aspirated
#> 10         10              10 3.962371 4.462383  20    k    velar aspirated
```

It makes no difference of course! /b d g p t k/ are identical in IPA and
X-SAMPA. But this is what happens when `feature_lookup()` is used with
an IPA character which *doesn’t* exist as an X-SAMPA character.

``` r
feature_lookup(phon='ø', feature='length')
#> Error in feature_lookup(phon = "ø", feature = "length"): I am unfamiliar with ø
#>  Definitions for unknown characters can be added with the feature_assign() function.
```

The function throws a warning saying that the character is unknown.
Let’s try again with `ipa=TRUE`:

``` r
feature_lookup(phon='ø', feature='length', ipa=TRUE)
#> [1] "short"
```

Say you have a data frame with IPA characters, and the sound /ø/ is
always long in the language, so you want to change the `length` value to
`long`. `feature_reassign()` only accepts X-SAMPA characters, but fear
not! The function `ipa::ipa()` is used under the hood to convert IPA
characters to X-SAMPA characters, so you can simply reassign the
corresponding X-SAMPA character (in this case `2`):

``` r
lkup <- feature_reassign(sampa='2', feature='length', val='long')
feature_lookup(phon='ø', feature='length', lookup=lkup, ipa=TRUE)
#> [1] "long"
```

### Adding new characters

You may want to use `add_features()` with a data frame where, for one
reason or another, you have been using non-standard symbols. For
example, you’ve been using `ph` instead of the standard X-SAMPA `p_h` to
indicate an aspirated bilabial stop. In this case, `feature_lookup()`
will shoot you an error:

``` r
feature_lookup(phon='ph')
#> Error in feature_lookup(phon = "ph"): I am unfamiliar with ph
#>  Definitions for unknown characters can be added with the feature_assign() function.
```

Again, fear not! The `feature_assign` function can help with creating a
customized lookup table with new characters. This feature also allows
you to copy the features from a known character, or a character with
known diacritics, using the `copy` argument. For our `ph` case, you
would do the following:

``` r
lkup <- feature_assign(new='ph', copy='p_h')
feature_lookup(phon='ph', lookup=lkup)
#>     height backness roundness    place major_place manner major_manner
#> 103                           bilabial      labial   stop    obstruent
#>           lar     voice length modifications syllabic  release nasalization
#> 103 aspirated voiceless  short            NA       no released           no
#>     tone
#> 103   NA
```

`feature_assign` also allows you to build your own feature sets from
scratch:

``` r
lkup <- feature_assign(new='kh',
                       feature=c('place', 'manner', 'lar'),
                       val=c('velar', 'stop', 'aspirated'))
feature_lookup(phon='kh', lookup=lkup)
#>     height backness roundness place major_place manner major_manner       lar
#> 103   <NA>     <NA>      <NA> velar        <NA>   stop         <NA> aspirated
#>     voice length modifications syllabic release nasalization tone
#> 103  <NA>   <NA>            NA     <NA>    <NA>         <NA>   NA
```

Or you can copy a known character and change some of the features (say,
if you’ve been using `th` to refer to a long, dental aspirated stop):

``` r
lkup <- feature_assign(new='th',
                       feature=c('place', 'length'),
                       val=c('dental', 'long'),
                       copy='t_h')
feature_lookup(phon='th', lookup=lkup)
#>     height backness roundness  place major_place manner major_manner       lar
#> 103                           dental     coronal   stop    obstruent aspirated
#>         voice length modifications syllabic  release nasalization tone
#> 103 voiceless   long            NA       no released           no   NA
```

You can bulk add new characters using `feature_assign` assuming they can
all be copied from known characters, or that the same feature needs to
be manipulated for all of them. In the following code block, features
are bulk added from known characters:

``` r
lkup <- feature_assign(new=c('ph', 'th', 'kh'),
                       copy=c('p_h', 't_h', 'k_h'))
tail(lkup, 3)
#>     segm height backness roundness    place major_place manner major_manner
#> 103   ph                           bilabial      labial   stop    obstruent
#> 104   th                           alveolar     coronal   stop    obstruent
#> 105   kh                              velar      dorsal   stop    obstruent
#>           lar     voice length modifications syllabic  release nasalization
#> 103 aspirated voiceless  short            NA       no released           no
#> 104 aspirated voiceless  short            NA       no released           no
#> 105 aspirated voiceless  short            NA       no released           no
#>     tone
#> 103   NA
#> 104   NA
#> 105   NA
```

Say you have been using `ph`, `th`, `kh` for preaspirated stop. They can
be bulk added like this:

``` r
lkup <- feature_assign(new=c('hp', 'ht', 'hk'),
                       feature='lar',
                       val='preaspirated',
                       copy=c('p', 't', 'k'))
tail(lkup, 3)
#>     segm height backness roundness    place major_place manner major_manner
#> 103   hp                           bilabial      labial   stop    obstruent
#> 104   ht                           alveolar     coronal   stop    obstruent
#> 105   hk                              velar      dorsal   stop    obstruent
#>              lar     voice length modifications syllabic  release nasalization
#> 103 preaspirated voiceless  short            NA       no released           no
#> 104 preaspirated voiceless  short            NA       no released           no
#> 105 preaspirated voiceless  short            NA       no released           no
#>     tone
#> 103   NA
#> 104   NA
#> 105   NA
```

Unfortunately, `feature_assign` does not at present allow you to add
unknown IPA characters.

## Contact

If you run into any problems using `phonfeatures`, feel free to leave a
bug report on [GitHub](https://github.com/rpuggaardrode/phonfeatures) or
reach out at r.puggaard at phonetik.uni-muenchen.de
