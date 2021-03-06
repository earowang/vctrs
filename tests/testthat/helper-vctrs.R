
import_from <- function(ns, names, env = caller_env()) {
  skip_if_not_installed(ns)
  objs <- env_get_list(ns_env(ns), names)
  env_bind(env, !!!objs)
}

vec_ptype2_fallback <- function(x, y, ...) {
  vec_ptype2_params(x, y, ..., df_fallback = TRUE)
}
vec_ptype_common_fallback <- function(..., .ptype = NULL) {
  vec_ptype_common_params(..., .ptype = .ptype, .df_fallback = TRUE)
}

shaped_int <- function(...) {
  array(NA_integer_, c(...))
}
