# SkiPasses example database.
This package is an example to be used in an R programming course where
we simulate a database for a ski resort that keeps track of all the 
season passes they've sold over a number of years.

The database includes the following tables:

## Customers 
| Column |  Interpretation          |
|:------:|:-------------------------|
| `PersonID` | The database key identifier.  |
| `GivenName`| The customers first name. |
| `Surname`  | The customers last name.  |
| `StreetAddress` | The customers Street address.  |
| `City` | The customer's City.|
| `State` | The customer's State |
| `ZipCode` | The customer's Zip Code. |
| `Gender`   | The gender of the customer. |
| `Birthday` | The customer's birthday  |

## Passes
|  Column  |   Interpretation                    |
|:--------:|:------------------------------------|
| `PersonID` | The database key identifier for a person. |
| `PassID`   | The database key identifier for a seaons pass. |
| `Season`   | The ski season for which the pass is bought for. |
| `PassType` | The type of pass that was bought. |
| `Start`    | The start date for when the pass works.  |
| `End`      | The ending date for when the pass works. |

## Pass Types
The `PassTypes` table keeps track of all the season pass types that we are
selling in each year.

|  Column  |   Interpretation                    |
|:--------:|:------------------------------------|
| `Season`   | The season the pass was sold.     |
| `PassType` | The name of the season pass type. |


## Black Out Dates
Some season passes are cheaper because they have blackout dates where the
customer can't ride. This could just be holiday weekends or possibly all
weekends. The dates in the table are dates where the user cannot ride.

|  Column  |   Interpretation                    |
|:--------:|:------------------------------------|
| `PassType` | The type of pass.                 |
| `Date`     | The date that is blacked out.     |

## Patrol Issues
Because some customers do dangerous or inapproriate things, the ski patrol is
authorized to suspend or revoke a customer's pass.

|  Column  |   Interpretation                    |
|:--------:|:------------------------------------|
| `PersonID` | The database key identifier for a person. |
| `Date` | The date of the patrol interaction.           |
| `Issue` | The description of the incident.             |


