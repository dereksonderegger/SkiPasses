#' Customers
#'
#' This table is contains all the customers that have ever bought a season pass.
#' We store the customers address here because we don't care about a customer's
#' historical address. So updates to a customers address here is fine.
#'
#' @format A data frame with the following columns:
#' \describe{
#' \item{PersonID}{A unique identifier identifying a person within the database.}
#' \item{GivenName}{The customer's first name.}
#' \item{SurName}{The customer's last name.}
#' \item{StreetAddress}{The street address}
#' \item{City}{City of the customer}
#' \item{State}{State of the customer's address}
#' \item{ZipCode}{Zipcode of the customer's address}
#' \item{Birthday}{Customer's date of Birth}
#' }
"Customers"
