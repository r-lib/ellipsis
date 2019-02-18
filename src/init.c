#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP ellipsis_promise_forced(SEXP);
extern SEXP ellipsis_dots(SEXP, SEXP);
extern SEXP ellipsis_eval_bare(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"ellipsis_dots", (DL_FUNC) &ellipsis_dots, 2},
    {"ellipsis_promise_forced", (DL_FUNC) &ellipsis_promise_forced, 1},
    {"ellipsis_eval_bare", (DL_FUNC) &ellipsis_eval_bare, 2},
    {NULL, NULL, 0}
};

void R_init_ellipsis(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
