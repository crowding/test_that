#' Expectation class.
#'
#' Any expectation should return objects of this class - see the built in
#' expectations for details.
#'
#' @param passed a single logical value indicating whether the test passed
#'  (\code{TRUE}), failed (\code{FALSE}), or threw an error (\code{NA})
#' @param failure_msg A text description of failure
#' @param success_msg A text description of success
#' @aliases expectation print.expectation format.expectation
#' @keywords internal
#' @export
expectation <- function(passed, failure_msg, success_msg = "unknown") {
  error <- is.na(passed)
  passed <- passed & !error

  structure(
    list(
      passed = passed, error = error,
      failure_msg = failure_msg, success_msg = success_msg
    ),
    class = "expectation"
  )
}

#' @export
#' @rdname expectation
#' @param x object to test for class membership
is.expectation <- function(x) inherits(x, "expectation")

#' @S3method print expectation
print.expectation <- function(x, ...) cat(format(x), "\n")

#' @S3method format expectation
format.expectation <- function(x, ...) {
  if (x$passed) {
    paste0("As expected: ", x$success_msg)
  } else {
    paste0("Not expected: ", x$failure_msg, ".")
  }
}

negate <- function(expt) {
  stopifnot(is.expectation(expt))

  # If it's an error, don't need to do anything
  if (expt$error) return(expt)

  opp <- expt
  opp$passed <- !expt$passed
  opp$failure_msg <- expt$success_msg
  opp$success_msg <- expt$failure_msg
  opp

}
