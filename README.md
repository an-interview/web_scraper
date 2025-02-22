# Web Scraper Backend in ROR

## Security Assumptions
- Advanced API security is not implemented. Basic API KEY authentication is implemented.
- ROR CORS is allowed for localhost 3001. This should be changed as per your react URL.

## Assumptions
- CSS Selector for scraping data are stored directly in code for simple project implementation. In future for complex proejct we will have to move it to rails models.

## Setup
- Install PostgreSQL database and create two roles for dev, test and production.
- Set three environement vairables as `WEB_SCRAPER_DB_URL` for production, `TRIP_TEST_DB_URL` for test and `TRIP_DEV_DB_URL` for development environment in the format of `"postgres://username:password@host/database_name"`
- Install Rails version 7
- Install Node >= 18
- Clone this repository and `cd` to the directory and do `bundle install`
- Run `bin/rails db:migrate` to apply all Database migrations.
- Run `rspec` to run all Rspec tests
- For production build do `bin/rails assets:precompile`
- Start Background job runner using `bundle exec sidekiq`
- `bin/dev` to start development server.
