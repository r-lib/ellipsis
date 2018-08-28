#define R_NO_REMAP
#define USE_RINTERNALS
#include <R.h>
#include <Rinternals.h>

SEXP ellipsis_promise_forced(SEXP x) {
  if (TYPEOF(x) != PROMSXP)
    return Rf_ScalarLogical(TRUE);

  SEXP value = PRVALUE(x);
  return Rf_ScalarLogical(value != R_UnboundValue);
}
