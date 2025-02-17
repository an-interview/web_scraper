# Web Scraper Backend in ROR

## Security Assumptions
- Advanced API security is not implemented. Basic API KEY authentication is implemented.
- ROR CORS is allowed for localhost 3001. This should be changed as per your react URL.

## Setup
- Install PostgreSQL database and create two roles for dev, test and production.
- Set three environement vairables as `WEB_SCRAPER_DB_URL` for production, `TRIP_TEST_DB_URL` for test and `TRIP_DEV_DB_URL` for development environment in the format of `"postgres://username:password@host/database_name"`
- Install Rails version 7
- Install Node >= 18
- Clone this repository and `cd` to the directory and do `bundle install`
- Run `rspec` to run all Rspec tests
- For production build do `bin/rails assets:precompile`
- Start Background job runner using `bundle exec sidekiq`
- `bin/dev` to start development server.
