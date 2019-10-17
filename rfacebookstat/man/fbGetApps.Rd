\name{fbGetApps}
\alias{fbGetApps}

\title{Get all the apps under a project}
\description{Get data frame with list apps under a project.}
\usage{
fbGetApps(projects_id = NULL, api_version = getOption("rfacebookstat.api_version"), 
          access_token = getOption("rfacebookstat.access_token"))
}
\arguments{
  \item{projects_id}{ Your project ID.}
  \item{api_version}{Current Facebook API version.}
  \item{access_token}{Your facebook API token.}
}

\value{
Data frame with apps list.
}

\author{Alexey Seleznev}


\examples{
\dontrun{
fbApps <- fbGetApps(projects_id = "xxxxxxxxxxxxx", 
                    api_version = "v2.8",
 					access_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
}
}

