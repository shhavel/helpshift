# Helpshift [![Build Status](https://travis-ci.org/shhavel/helpshift.svg?branch=master)](https://travis-ci.org/shhavel/helpshift)

Ruby wrapper for [Helpshift REST APIs](https://apidocs.helpshift.com/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'helpshift'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install helpshift

## Configuration

```ruby
Helpshift.configure do |config|
  config.customer_domain = 'oreillys-sbox'
  config.api_key = 'oreillys-sbox_api_1234-abcd'
end
```

## Usage

###### Create Issues:
```ruby
body = {
  email: 'your.email@yourdomain.com',
  'title' => 'this is your title',
  'message-body' => 'This is the message body'
}
resp = Helpshift.post('/issues/', body)

```

###### Get Issues:

All Issues:
```ruby
resp = Helpshift.get('/issues')
resp['issues']
```

Single Issue:
```ruby
resp = Helpshift.get("/issues/#{issue_id}")
resp['issues']
```
###### Update Custom Issue Fields

Configure issue fields in Helpshift admin - https://[customer_domain].helpshift.com/admin/.
Navigate to Settings > Custom Issue Fields.

Then you can update custom fields for any issue:

```ruby
resp = Helpshift.put('/issues/4', custom_fields: { my_number_field: { type: 'number', value: 43 } }.to_json)
resp['updated-data']['custom_fields']) #=> {'my_number_field' => { 'type' => 'number', 'value' => 43 }}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shhavel/helpshift. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
