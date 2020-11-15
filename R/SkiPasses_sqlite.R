#' Create database connection for Ski Passes Database
#'
#' This function pulls the example Ski Pass data into a sqlite database. If
#' the user has specified a `path`, then we'll save the database to a file, which
#' can be subsequently updated.
#'
#' There are five tables we are interested in:
#'
#' `Customers` is contains personal information about each customer.
#'
#' `Passes` contains information about each season pass. In particular a single
#'          customer might have season passes in different years. Furthermore
#'
#' `PassTypes` This table contains all the different pass types sold for each year.
#'
#' `BlackOutDates` Certain passes have black-out dates where the customer is not
#'                 allowed to ski. These are typically on busy vacation weekends.
#'                 Also the Weekday pass has *every* weekend blacked out.
#'
#' `PatrolIssues` This table documents any time a customer has their pass pulled
#'                due to hooligan behavior such as ducking boundary ropes and
#'                building jumps in dangerous locations.

#' @param path The sqlite database file to be created. If missing, then the database
#'             is stored "in memory".
#' @export
SkiPasses_sqlite <- function(path=":memory:"){
  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = path)

  DBI::dbWriteTable(con, 'Customers',    as.data.frame(SkiPasses::Customers))
  DBI::dbWriteTable(con, 'Passes',       as.data.frame(SkiPasses::Passes))
  DBI::dbWriteTable(con, 'PassTypes',    as.data.frame(SkiPasses::PassTypes))
  DBI::dbWriteTable(con, 'BlackOutDates',as.data.frame(SkiPasses::BlackOutDates))
  DBI::dbWriteTable(con, 'PatrolIssues', as.data.frame(SkiPasses::PatrolIssues))

  return(con)
}
