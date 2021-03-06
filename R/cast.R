#' Cast a vector to a specified type
#'
#' @description
#'
#' `vec_cast()` provides directional conversions from one type of
#' vector to another. Along with [vec_ptype2()], this generic forms
#' the foundation of type coercions in vctrs.
#'
#' @includeRmd man/faq/developer/links-coercion.Rmd
#'
#' @param x Vectors to cast.
#' @param ... For `vec_cast_common()`, vectors to cast. For
#'   `vec_cast()`, `vec_cast_default()`, and `vec_restore()`, these
#'   dots are only for future extensions and should be empty.
#' @param to,.to Type to cast to. If `NULL`, `x` will be returned as is.
#' @param x_arg,to_arg Argument names for `x` and `to`. These are used
#'   in error messages to inform the user about the locations of
#'   incompatible types (see [stop_incompatible_type()]).
#' @return A vector the same length as `x` with the same type as `to`,
#'   or an error if the cast is not possible. An error is generated if
#'   information is lost when casting between compatible types (i.e. when
#'   there is no 1-to-1 mapping for a specific value).
#'
#' @seealso Call [stop_incompatible_cast()] when you determine from the
#' attributes that an input can't be cast to the target type.
#' @export
#' @examples
#' # x is a double, but no information is lost
#' vec_cast(1, integer())
#'
#' # When information is lost the cast fails
#' try(vec_cast(c(1, 1.5), integer()))
#' try(vec_cast(c(1, 2), logical()))
#'
#' # You can suppress this error and get the partial results
#' allow_lossy_cast(vec_cast(c(1, 1.5), integer()))
#' allow_lossy_cast(vec_cast(c(1, 2), logical()))
#'
#' # By default this suppress all lossy cast errors without
#' # distinction, but you can be specific about what cast is allowed
#' # by supplying prototypes
#' allow_lossy_cast(vec_cast(c(1, 1.5), integer()), to_ptype = integer())
#' try(allow_lossy_cast(vec_cast(c(1, 2), logical()), to_ptype = integer()))
#'
#' # No sensible coercion is possible so an error is generated
#' try(vec_cast(1.5, factor("a")))
#'
#' # Cast to common type
#' vec_cast_common(factor("a"), factor(c("a", "b")))
vec_cast <- function(x, to, ..., x_arg = "", to_arg = "") {
  if (!missing(...)) {
    ellipsis::check_dots_empty()
  }
  return(.Call(vctrs_cast, x, to, x_arg, to_arg))
  UseMethod("vec_cast", to)
}
vec_cast_dispatch <- function(x, to, ..., x_arg = "", to_arg = "") {
  UseMethod("vec_cast", to)
}

#' @export
#' @rdname vec_cast
vec_cast_common <- function(..., .to = NULL) {
  .External2(vctrs_cast_common, .to)
}

#' @rdname vec_default_ptype2
#' @inheritParams vec_cast
#' @export
vec_default_cast <- function(x, to, ..., x_arg = "", to_arg = "") {
  if (is_asis(x)) {
    return(vec_cast_from_asis(x, to, x_arg = x_arg, to_arg = to_arg))
  }
  if (is_asis(to)) {
    return(vec_cast_to_asis(x, to, x_arg = x_arg, to_arg = to_arg))
  }

  if (inherits(to, "vctrs_vctr") && !inherits(to, c("vctrs_rcrd", "vctrs_list_of"))) {
    return(vctr_cast(x, to, x_arg = x_arg, to_arg = to_arg))
  }

  # Compatibility for sfc lists (#989)
  if (inherits(x, "sfc") || inherits(to, "sfc")) {
    return(UseMethod("vec_cast", to))
  }

  # If both data frames, first find the `to` type of columns before
  # the same-type fallback
  if (df_needs_normalisation(x, to)) {
    x <- vec_cast_df_fallback_normalise(x, to)
  }

  if (is_same_type(x, to)) {
    return(x)
  }

  if (has_df_fallback() && match_df_fallback(...)) {
    out <- df_cast_params(x, to, ..., x_arg = x_arg, to_arg = to_arg, df_fallback = TRUE)

    if (inherits(to, "tbl_df")) {
      out <- df_as_tibble(out)
    }

    return(out)
  }

  stop_incompatible_cast(
    x,
    to,
    x_arg = x_arg,
    to_arg = to_arg,
    `vctrs:::from_dispatch` = match_from_dispatch(...)
  )
}

is_informative_error.vctrs_error_cast_lossy <- function(x, ...) {
  FALSE
}
