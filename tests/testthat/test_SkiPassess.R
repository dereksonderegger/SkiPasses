
test_that('Setup tables are not user accessable', {
  con <- SkiPasses_sqlite(refresh=TRUE)
  expect_error(Passes)
  expect_error(PassTypes)
  expect_error(BlackOutDates)
  expect_error(Customers)
  expect_error(PatrolIssues)
  DBI::dbDisconnect(con)
})
