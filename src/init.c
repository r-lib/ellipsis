#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .Call calls */
extern SEXP ellipsis_promise_forced(SEXP);
extern SEXP ellipsis_dots(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"ellipsis_dots", (DL_FUNC) &ellipsis_dots, 1},
    {"ellipsis_promise_forced", (DL_FUNC) &ellipsis_promise_forced, 1},
    {NULL, NULL, 0}
};

void R_init_ellipsis(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
