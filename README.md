# D326_AdvancedDataManagement
This code defines a set of SQL operations using PostgreSQL for managing a movie rental database. Here's a breakdown of the code:

### Part B: Transformations
This part includes a PostgreSQL function named `rentalMonth`, which extracts the month from a given timestamp (`rental_date`) and returns an integer representing the month.

### Part C: Creates Detailed and Summary table
Defines two tables: `Detailed` and `Summary`. 
- `Detailed` stores detailed information about rentals, including rental ID, customer ID, film ID, category ID, title, film category, payment ID, and rental month.
- `Summary` stores a summary of rental data, including the film category and the total number of rentals within each category.

### Part D: Extracts raw data for detailed table
Populates the `Detailed` table by selecting relevant data from multiple tables (`rental`, `inventory`, `film`, `film_category`, `category`, and `payment`) using JOIN operations.

### Part E: Procedure
Defines a trigger function (`summary_trigger_function`) and creates a trigger (`update_summary`). The trigger function updates the `Summary` table by deleting existing data and inserting a new summary based on the contents of the `Detailed` table. The trigger is executed after each `INSERT` statement on the `Detailed` table.

### Part F: Stored Procedures
Defines a stored procedure (`refresh_tables`) that deletes data from both the `Detailed` and `Summary` tables and repopulates them by performing the same data extraction as in Part D. It also includes a call to this procedure.

### Part F TEST
This section includes test calls to the `refresh_tables` stored procedure and verifies the changes by counting the number of rows in the `Detailed` table before and after the procedure call.

In summary, the code sets up a database schema for managing movie rental information, including detailed records and summary statistics, and provides functions and procedures for extracting, transforming, and loading data into these tables. Additionally, it includes triggers to automatically update summary information when new rental details are added.
