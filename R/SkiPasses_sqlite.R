#' Create database connection for Ski Passes Database
#'
#' This function pulls the example Ski Pass data into a SQLite database file and
#' returns a connection object. If
#' the user has specified a `path`, we'll use the specified location, otherwise
#' we use a file stored where ever the package was installed. Subsequent sessions
#' will maintain modifications from previous sessions.
#'
#' @param path The sqlite database file to be created. If missing, then the
#'             will be created where the R package has been installed to.
#'             If you want to not store your results permanently, use
#'             ':memory:'.
#'
#' @param refresh Should we return the database to the unmodified version that
#'             comes with the package. This is useful if the data has been modified,
#'             deleted, or otherwise mangled beyond use.
#'
#' There are five tables we are interested in:
#'
#' * `Customers` contains personal information about each customer.
#'
#' * `Passes` contains information about each season pass. In particular a single
#'          customer might have season passes in different years. Furthermore a
#'          customer might have "lost" a pass and we had to re-issue it. To prevent
#'          a "lost" pass being used by somebody else, we need to invalidate the lost
#'          one and issue a completely new one to the customer.
#'
#' * `PassTypes` This table contains all the different pass types sold for each year.
#'
#' * `BlackOutDates` Certain passes have black-out dates where the customer is not
#'                 allowed to ski. These are typically on busy vacation weekends.
#'                 Also the Weekday pass has *every* weekend blacked out.
#'
#' * `PatrolIssues` This table documents any time a customer has their pass pulled
#'                due to hooligan behavior such as ducking boundary ropes and
#'                building jumps in dangerous locations.
#'
#' @examples
#' con <- SkiPasses_sqlite()  # By default, it connects to a /inst/extdata file
#' DBI::dbExecute(con,
#'   "INSERT into Customers(PersonID, GivenName, Surname,
#'                          StreetAddress, City, State, ZipCode,
#'                          Gender, Birthday)
#'    VALUES (1000, 'John', 'Doe',
#'            '876 Lost Trail','Flagstaff','AZ','86004',
#'            'male', '1978-01-11')"
#' )
#' DBI::dbGetQuery(con, "SELECT * from Customers WHERE GivenName = 'John'")
#' DBI::dbDisconnect(con)
#'
#' # Where is the default SQLite databse file stored?
#' system.file("extdata", "SkiPasses.db", package = "SkiPasses")
#'
#'
#' # In subsequent sessions, the new customer is still there!
#' con <- SkiPasses_sqlite()  # By default, it connects to a /inst/extdata file
#' DBI::dbGetQuery(con, "SELECT * from Customers WHERE GivenName = 'John'")
#' DBI::dbDisconnect(con)
#'
#' # If we want to return the database to the completely fresh initial state
#' con <- SkiPasses_sqlite(refresh=TRUE)
#' DBI::dbGetQuery(con, "SELECT * from Customers WHERE GivenName = 'John'")
#' DBI::dbDisconnect(con)
#'
#' @export
SkiPasses_sqlite <- function(path=NULL, refresh=FALSE){
  if(is.null(path)){
    path = system.file("extdata", "SkiPasses.db", package = "SkiPasses")
  }
  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = path)
  # browser()
  if( length(DBI::dbListTables(con)) == 0 | refresh==TRUE ){
    DBI::dbWriteTable(con, 'Customers',    as.data.frame(SkiPasses::Customers), overwrite=TRUE)
    DBI::dbWriteTable(con, 'Passes',       as.data.frame(SkiPasses::Passes), overwrite=TRUE)
    DBI::dbWriteTable(con, 'PassTypes',    as.data.frame(SkiPasses::PassTypes), overwrite=TRUE)
    DBI::dbWriteTable(con, 'BlackOutDates',as.data.frame(SkiPasses::BlackOutDates), overwrite=TRUE)
    DBI::dbWriteTable(con, 'PatrolIssues', as.data.frame(SkiPasses::PatrolIssues), overwrite=TRUE)
  }
  return(con)
}
