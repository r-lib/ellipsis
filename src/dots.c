#define R_NO_REMAP
#define USE_RINTERNALS
#include <R.h>
#include <Rinternals.h>
#include <stdio.h>

SEXP ellipsis_dots(SEXP env) {
  if (TYPEOF(env) != ENVSXP)
    Rf_errorcall(R_NilValue, "`env` is a not an environment");

  SEXP dots = PROTECT(Rf_findVarInFrame3(env, R_DotsSymbol, TRUE));
  if (dots == R_UnboundValue)
    Rf_errorcall(R_NilValue, "No ... found");

  // Empty dots
  if (dots == R_MissingArg) {
    UNPROTECT(1);
    return Rf_allocVector(VECSXP, 0);
  }


  int n = 0;
  for(SEXP nxt = dots; nxt != R_NilValue; nxt = CDR(nxt)) {
    n++;
  }

  SEXP out = PROTECT(Rf_allocVector(VECSXP, n));
  SEXP names = PROTECT(Rf_allocVector(STRSXP, n));
  Rf_setAttrib(out, R_NamesSymbol, names);

  for (int i = 0; i < n; ++i) {
    SET_VECTOR_ELT(out, i, CAR(dots));

    SEXP name = TAG(dots);
    if (TYPEOF(name) == SYMSXP) {
      SET_STRING_ELT(names, i, PRINTNAME(name));
    } else {
      char buffer[10];
      snprintf(buffer, 10, "..%i", i + 1);
      SET_STRING_ELT(names, i, Rf_mkChar(buffer));
    }

    dots = CDR(dots);
  }

  UNPROTECT(3);

  return out;

}

SEXP ellipsis_promise_forced(SEXP x) {
  if (TYPEOF(x) != PROMSXP)
    return Rf_ScalarLogical(TRUE);

  SEXP value = PRVALUE(x);
  return Rf_ScalarLogical(value != R_UnboundValue);
}
