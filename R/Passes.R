#' Passes
#'
#' This dataset contains information about each season pass bought. We have
#' columns for the person that bought the pass along with the ski season the
#' pass was bought for and the type of pass. The Start and Finish dates denote
#' when the pass is applicable.
#'
#' If a person has their pass revoked or suspended for some
#' reason, we'll adjust the Finish date. If the pass is re-instated, we will
#' insert another row in the table with a Start value at the end of the
#' suspension period and Finish at the end of the season. If a customer keeps
#' getting their pass revoked multiple times in a season, they will have several rows in
#' this table.
#'
#' @format A data frame with 5 columns.
#' \describe{
#' \item{PersonID}{A unique identifier identifying a person within the database.}
#' \item{Season}{The season the pass was issued for.}
#' \item{PassType}{The pass type.}
#' \item{Start}{The Start date for when the pass is active.}
#' \item{Finish}{The finish date for when the pass is active.}
#' }
"Passes"
