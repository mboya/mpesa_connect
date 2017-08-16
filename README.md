# MpesaConnect

Gem built as ruby wrapper to handle transactions with with the [Safaricom API](https://developer.safaricom.co.ke/docs)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mpesa_connect'
```

And then execute:

    `$ bundle`

Or install it yourself as:

    `$ gem install mpesa_connect`

## Usage

```ruby
  require 'mpesa_connect'
```

Values you need from your Safaricom app

- `key` and `secret`: this is for the approved app
- `security_password`: generated from the sandbox tool for encrypting Security Credential (Shortcode 1)

```ruby
  client = MpesaConnect::Client.new(key, secret, security_password)
```

Set the urls that will be used to send response back to your app

- `timeout_url`: when there is a connection break.
- `transaction_url`: when the request is successful and json response is sent to.

```ruby
  client.set_urls(timeout_url, transaction_url)
```

For each of the functions you will need data from Test Credentials:

- `initiator`: Initiator Name (Shortcode 1)
- `party_a`: Shortcode 1
- `party_b`: Test MSISDN
- `receiver_party`: Shortcode 1

### Account Balance

```ruby
  client.account_balance(initiator, party_a)
```

### Reversal

```ruby
  client.reversal(initiator, transaction_id, amount, receiver_party)
```

### Transaction Status

```ruby
  client.transaction_status(initiator, party_a, transaction_id)
```

### B2C Transaction

Salary Payment

```ruby
  client.b2c_transaction(initiator, amount, party_a, party_b)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mboya/mpesa_connect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MpesaConnect project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mboya/mpesa_connect/blob/master/CODE_OF_CONDUCT.md).
