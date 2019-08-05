# MBank

## Dependencies

To run this project you need to have:

* Ruby 2.6.3
* PostgreSQL

## Setup the project

1. Install the dependencies above
2. `$ git clone <REPOSITORY_URL> mbank` - Clone the project
3. `$ cd mbank` - Go into the project folder
4. `$ bin/setup` - Run the setup script
5. `$ bin/rspec` - Run the specs to see if everything is working fine

## Running the project

* bundle exec rails s

## Running specs

* bundle exec rspec

## API

### Create Account
```
curl -H 'Content-Type: application/json' -X POST 'http://localhost:3000/accounts/'
```

### Create Deposit
```
curl -H 'Content-Type: application/json' -d '{"destination_account_id": 2, "amount": 100.00}' -X POST 'http://localhost:3000/deposits'
```

### Create Transfer
```
curl -H 'Content-Type: application/json' -d '{"source_account_id": 1, "destination_account_id": 2, "amount": 100.00}' -X POST 'http://localhost:3000/transfers'
```

### Show Balance
```
curl -H 'Content-Type: application/json' -X GET 'http://localhost:3000/accounts/:account_id/balance'
```

## Contributing
* Fork it
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Add some feature')
* Push to the branch (git push origin my-new-feature)
* Create new Pull Request
