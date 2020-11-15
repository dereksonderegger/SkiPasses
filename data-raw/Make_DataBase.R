library(tidyverse)
library(lubridate)

set.seed(8675309)

PassTypes <- tribble(
    ~Season,       ~PassType,
    '2019-2020',  'PowerKidsPass',
    '2019-2020',  'PowerPass',
    '2019-2020',  'PowerPassSelect',
    '2019-2020',  'Weekday',
    '2020-2021',  'PowerKidsPass',
    '2020-2021',  'PowerPass',
    '2020-2021',  'PowerPassSelect',
    '2020-2021',  'Weekday')
usethis::use_data(PassTypes, overwrite = TRUE)


BlackOutDates <-
    rbind(
      expand.grid(PassType ='PowerPassSelect',
                  Date=lubridate::ymd(paste('2019-12',26:31, sep='-'))),
      expand.grid(PassType ='PowerPassSelect',
                  Date=lubridate::ymd(paste('2020-01',    1, sep='-'))),
      expand.grid(PassType ='PowerPassSelect',
                  Date=lubridate::ymd(paste('2020-01',19:20, sep='-'))),
      expand.grid(PassType ='PowerPassSelect',
                  Date=lubridate::ymd(paste('2020-02',16:17, sep='-'))),

      expand.grid(PassType ='PowerPassSelect',
                  Date=lubridate::ymd(paste('2020-12',26:31, sep='-'))),
      expand.grid(PassType ='PowerPassSelect',
                  Date=lubridate::ymd(paste('2021-01',16:17, sep='-'))),
      expand.grid(PassType ='PowerPassSelect',
                  Date=lubridate::ymd(paste('2021-02',13:14, sep='-')))
    )

all_weekends <- function(start, end){
  tibble(day = seq(start, end, by=1) )  %>%
    filter( lubridate::wday(day) %in% c(1,7) ) %>%
    pull(day) %>%
    return()
}

BlackOutDates <- rbind(
  BlackOutDates,
  expand.grid(PassType='Weekday', Date=unique(BlackOutDates$Date)),
  expand.grid(PassType='Weekday', Date=all_weekends(ymd('2019-11-20'),ymd('2020-4-20'))),
  expand.grid(PassType='Weekday', Date=all_weekends(ymd('2021-11-20'),ymd('2022-4-20')))
)
usethis::use_data(BlackOutDates, overwrite = TRUE)

# Adults
FakeNames  <-
  read_csv('~/GitHub/444/data-raw/FakeNameGenerator.csv') %>%
  sample_frac(n=n(), resample=TRUE) %>%
  mutate(City='Flagstaff', State='AZ', ZipCode='86004') %>%
  select(-MiddleInitial, -Birthday) %>%
  mutate(PersonID=1:n())


Customers <- NULL
Passes    <- NULL

# Single Skier Households 20-70
n <- 20
NewCustomers <-
  FakeNames %>% slice(  1:n) %>%
  mutate(Birthday = today() - years(round(runif(n, 20, 70))) - days(round(runif(n, 0, 365))) )
NewPasses <-
  expand.grid(
  PersonID = FakeNames[1:n, 'PersonID'] %>% pull(1),
  Season = c('2019-2020', '2020-2021')) %>%
  mutate(PassType = sample(c('PowerPass','PowerPassSelect','Weekday'), nrow(.), replace=TRUE)) %>%
  sample_frac(size=.75) %>%
  arrange(PersonID)
FakeNames <- FakeNames %>% slice(-(1:n))
Customers <- NewCustomers
Passes    <- NewPasses

# Young adults at the same address
for( i in 1:20 ){
  n <- rpois(1, lambda=2)
  while( n < 2 ){
    n <- rpois(1, lambda=2)
  }
  NewCustomers <-
    FakeNames %>% slice(  1:n) %>%
    mutate(Birthday = today() - years(round(runif(n, 20, 31))) - days(round(runif(n, 0, 365))) ) %>%
    mutate(StreetAddress = StreetAddress[1])
  NewPasses <- expand.grid(
    PersonID = FakeNames[1:n, 'PersonID'] %>% pull(1),
    Season = c('2019-2020', '2020-2021')) %>%
    mutate(PassType = sample(c('PowerPass','PowerPassSelect','Weekday'), nrow(.), replace=TRUE)) %>%
    sample_frac(size=.75)
  FakeNames <- FakeNames %>% slice(-(1:n))
  Customers <- Customers %>% rbind(NewCustomers)
  Passes    <- Passes    %>% rbind(NewPasses)
}

# Families
for( i in 1:20 ){
  n <- runif(1, min=1, max=2) %>% round()
  NewCustomers <-
    FakeNames %>% slice(  1:n) %>%
    mutate(Birthday = today() - years(round(runif(n, 25, 50))) - days(round(runif(n, 0, 365))) ) %>%
    mutate(StreetAddress = StreetAddress[1],
           Surname = Surname[1])
  address <- NewCustomers$StreetAddress[1]
  surname <- NewCustomers$Surname[1]
  NewPasses <- expand.grid(
    PersonID = FakeNames[1:n, 'PersonID'] %>% pull(1),
    Season = c('2019-2020', '2020-2021')) %>%
    mutate(PassType = sample(c('PowerPass','PowerPassSelect','Weekday'), nrow(.), replace=TRUE)) %>%
    sample_frac(size=.75)
  FakeNames <- FakeNames %>% slice(-(1:n))
  Customers <- Customers %>% rbind(NewCustomers)
  Passes    <- Passes    %>% rbind(NewPasses)

  n <- rpois(1, lambda=3)
  while( n == 0 ){
    n <- rpois(1, lambda=3)
  }
  NewCustomers <-
    FakeNames %>% slice(  1:n) %>%
    mutate(Birthday = today() - years(round(runif(n, 3, 18))) - days(round(runif(n, 0, 365))) ) %>%
    mutate(StreetAddress = address,
           Surname = surname)
  NewPasses <- expand.grid(
    PersonID = FakeNames[1:n, 'PersonID'] %>% pull(1),
    Season = c('2019-2020', '2020-2021')) %>%
    mutate(PassType = 'PowerKidsPass') %>%
    sample_frac(size=.75)
  FakeNames <- FakeNames %>% slice(-(1:n))
  Customers <- Customers %>% rbind(NewCustomers)
  Passes    <- Passes    %>% rbind(NewPasses)
}

Customers <- Customers %>%
  select(PersonID, GivenName, Surname, StreetAddress, City, State, ZipCode, Gender, Birthday)
usethis::use_data(Customers, overwrite = TRUE)


Passes <- Passes %>%
  mutate(Start = if_else(Season=='2019-2020',
                        ymd('2019-11-1'),
                        ymd('2020-11-1')),
         End = if_else(Season=='2019-2020',
                      ymd('2020-4-15'),
                      ymd('2021-4-15')))

Passes <- Passes %>%
  mutate(PassID = paste('Pass',1:n(), sep='_')) %>%
  select(PersonID, PassID, Season, PassType, Start, End)


insert_warning <- function(personID, date, issue, penalty=1){
  # browser()
  current <- Passes %>%
    filter(PersonID==personID, Start< date, date < End)
  if( nrow(current) == 1 ){
    current$Start = date + days(penalty)
    Passes <<- Passes %>%
      mutate(End = if_else(PersonID=={{personID}} & Start<{{date}} & {{date}} < End,
                          date, End)) %>%
      bind_rows(current)
    PatrolIssues <<- PatrolIssues %>%
      add_case(PersonID=personID, Date=date, Issue=issue)
  }
}

PatrolIssues <- data.frame(
  PersonID=1,
  Date=ymd('2020-1-11'),
  Issue='Ducked boundary rope off of Jeep Trail'
)

insert_warning(
  personID=1,
  date=ymd('2020-1-11'),
  issue='Ducked boundary rope off of Jeep Trail',
  penalty=2
)
PatrolIssues <- PatrolIssues %>% slice(1)


for( i in 1:20 ){
  punk <- Passes %>% slice_sample(n=1)
  Date = runif(1, min=punk$Start, max=punk$End) %>% as.Date(origin = "1970-01-01")
  Issue = sample(c('Ducking Ropes','Recklessness','Dangerous Building'), 1)
  Penalty = sample(1:7, 1)
  insert_warning(
    personID=punk$PersonID,
    date=Date,
    issue=Issue,
    penalty=Penalty)
}


usethis::use_data(Passes, overwrite = TRUE)
usethis::use_data(PatrolIssues, overwrite=TRUE)

