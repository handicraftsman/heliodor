# Heliodor

Heliodor is server-less database management tool

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heliodor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heliodor

## Usage

Next example creates new database file, table inside of it and inserts value

```ruby
require 'heliodor'
db = Heliodor::DB.new './example.db'
db
  .query('Users') # Perform query on table 'users'
  .ensure         # Ensure that this table exists - if it does not, create it
  .insert(first_name: 'Vasya', last_name: 'Pupkin', age: 20) # Insert data into table
  .write  # Write data
  .finish # Finish query - executes all statements

# Resulting table will be returned after finishing query

```

More info can be found [rubydoc](http://www.rubydoc.info/gems/heliodor)

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/handicraftsman/heliodor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

