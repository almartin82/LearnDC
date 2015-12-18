% Generated by roxygen2 (4.0.1.99): do not edit by hand
\name{GetExhibits}
\alias{GetExhibits}
\title{A Function to Return Exhibit Names from LearnDC's data exhibits.}
\usage{
GetExhibits("level")
}
\description{
This function retrieves the names of the exhibits from LearnDC.org's various levels of exhibits (school, LEA, sector, and state).
}
\author{
Benjamin Robinson, \email{benj.robinson2@gmail.com}
}
\references{
\url{http://learndc.org/schoolprofiles/search}
}
\examples{
GetExhibits("school")
GetExhibits("lea")
GetExhibits("sector")
GetExhibits("state")
}