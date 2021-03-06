% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/type-date-time.R
\name{new_date}
\alias{new_date}
\alias{new_datetime}
\alias{new_duration}
\alias{vec_ptype2.Date}
\alias{vec_ptype2.POSIXct}
\alias{vec_ptype2.POSIXlt}
\alias{vec_ptype2.difftime}
\alias{vec_cast.Date}
\alias{vec_cast.POSIXct}
\alias{vec_cast.POSIXlt}
\alias{vec_cast.difftime}
\alias{vec_arith.Date}
\alias{vec_arith.POSIXct}
\alias{vec_arith.difftime}
\title{Date, date-time, and duration S3 classes}
\usage{
new_date(x = double())

new_datetime(x = double(), tzone = "")

new_duration(x = double(), units = c("secs", "mins", "hours", "days", "weeks"))

\method{vec_ptype2}{Date}(x, y, ...)

\method{vec_ptype2}{POSIXct}(x, y, ...)

\method{vec_ptype2}{POSIXlt}(x, y, ...)

\method{vec_ptype2}{difftime}(x, y, ...)

\method{vec_cast}{Date}(x, to, ...)

\method{vec_cast}{POSIXct}(x, to, ...)

\method{vec_cast}{POSIXlt}(x, to, ...)

\method{vec_cast}{difftime}(x, to, ...)

\method{vec_arith}{Date}(op, x, y, ...)

\method{vec_arith}{POSIXct}(op, x, y, ...)

\method{vec_arith}{difftime}(op, x, y, ...)
}
\arguments{
\item{x}{A double vector representing the number of days since UNIX
epoch for \code{new_date()}, number of seconds since UNIX epoch for
\code{new_datetime()}, and number of \code{units} for \code{new_duration()}.}

\item{tzone}{Time zone. A character vector of length 1. Either \code{""} for
the local time zone, or a value from \code{\link[=OlsonNames]{OlsonNames()}}}

\item{units}{Units of duration.}
}
\description{
\itemize{
\item A \code{date} (\link{Date}) is a double vector. Its value represent the number
of days since the Unix "epoch", 1970-01-01. It has no attributes.
\item A \code{datetime} (\link{POSIXct} is a double vector. Its value represents the
number of seconds since the Unix "Epoch", 1970-01-01. It has a single
attribute: the timezone (\code{tzone}))
\item A \code{duration} (\link{difftime})
}
}
\details{
These function help the base \code{Date}, \code{POSIXct}, and \code{difftime} classes fit
into the vctrs type system by providing constructors, coercion functions,
and casting functions.
}
\examples{
new_date(0)
new_datetime(0, tzone = "UTC")
new_duration(1, "hour")
}
\keyword{internal}
