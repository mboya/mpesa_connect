# MpesaConnect

Gem built as ruby wrapper to handle transactions with with the [Safaricom M-Pesa APIs](https://developer.safaricom.co.ke/docs).
You will need to have a developer Account on [Safaricom Developer](https://developer.safaricom.co.ke/docs). Portal to run in sandbox environments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mpesa_connect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mpesa_connect

## Usage

```ruby
  require 'mpesa_connect'
```

Values you need from your Safaricom app

- `key` and `secret`:  Credentials for an approved app.
- `security_password`: Generated Encryption Security Credential from the sandbox tool (Shortcode 1).

```ruby
  client = MpesaConnect::Client.new(key, secret, security_password)
```

Set the urls that will be used to send response back to your app

- `timeout_url`    :  The callback URL that handles information of timed out transactions
- `transaction_url`:  The callback URL that handles a successful request and handles responses.

```ruby
  client.set_urls(timeout_url, transaction_url)
```

For each of the functions you will need data from Test Credentials:

- `Initiator`     : This is the credential/username used to authenticate the transaction request.
- `PartyA`        : Short code for party initiating the transaction.
- `PartyB`        : Organization/MSISDN(phone number) sending the transaction.
- `Receiver_party`: Identifier types - receiver - identify an M-Pesa transaction’s receiving party as either a shortcode, a till number or a MSISDN (phone number).

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

### C2B Transaction

first you need to setup the following

- `ConfirmationURL`  : Validation URL for the client
- `ValidationURL`    : Confirmation URL for the client
- `ResponseType`     : Cancelled or Completed
- `ShortCode`        : The short code of the organization. 


setup the required urls
```ruby
  client.set_urls(nil, nil, confirmation_url, validation_url)
```

Register URL

```ruby
  client.c2b_register_url(shortcode, response_type)
```

Simulate Transaction

```ruby
  client.c2b_transaction(shortcode, amount, msisdn, bill_reference)
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
