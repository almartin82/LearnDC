% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetExhibits.R
\name{GetExhibits}
\alias{GetExhibits}
\title{A Function to Return Exhibit Names from LearnDC's data exhibits.}
\usage{
GetExhibits("level")
}
\arguments{
\item{level}{character, an aggregation level - one of 
c("school","lea","sector","state")}
}
\value{
data frame
}
\description{
This function retrieves the names of the exhibits from 
LearnDC.org's various levels of exhibits (school, LEA, sector, and state
}
\examples{
GetExhibits("school")
GetExhibits("lea")
GetExhibits("sector")
GetExhibits("state")
}
\author{
Benjamin Robinson, \email{benj.robinson2@gmail.com}
}
\references{
\url{http://learndc.org/schoolprofiles/search}
}

