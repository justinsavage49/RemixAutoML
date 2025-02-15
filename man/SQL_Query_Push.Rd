% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SQL_Functions.R
\name{SQL_Query_Push}
\alias{SQL_Query_Push}
\title{SQL_Query_Push}
\usage{
SQL_Query_Push(DBConnection, Query, CloseChannel = TRUE)
}
\arguments{
\item{DBConnection}{RemixAutoML::SQL_Server_DBConnection()}

\item{Query}{The SQL statement you want to run}

\item{CloseChannel}{TRUE to close when done, FALSE to leave the channel open}
}
\description{
SQL_Query_Push push data to a database table
}
\seealso{
Other Database: 
\code{\link{AutoDataDictionaries}()},
\code{\link{PostGRE_AppendData}()},
\code{\link{PostGRE_CreateTable}()},
\code{\link{PostGRE_ListTables}()},
\code{\link{PostGRE_Query}()},
\code{\link{PostGRE_RemoveCreateAppend}()},
\code{\link{PostGRE_RemoveTable}()},
\code{\link{SQL_ClearTable}()},
\code{\link{SQL_DropTable}()},
\code{\link{SQL_Query}()},
\code{\link{SQL_SaveTable}()},
\code{\link{SQL_Server_DBConnection}()}
}
\author{
Adrian Antico
}
\concept{Database}
