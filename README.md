## Installation

This is a rudimentary Ruby binding for the [PayEx API].  You can
install it using RubyGems.

[PayEx API]: http://pim.payex.com/section3/section3_4_2.htm

```
gem install payex
```

## Usage

```ruby
require 'payex'

PayEx.account_number = 123456789
PayEx.encryption_key = 'e4939be3910ebu194'
PayEx.default_currency = 'SEK'
# PayEx.base_url = PayEx::TEST_URL # (use this for testing)

# (an arbitrary string you can use to identify this transaction)
my_order_id = 'c704acc45a4bec4c8cd50b73fb01a7c7'

# Credit card example:
payment_url = PayEx::Redirect.initialize!
  price: 14900, # (in cents)
  order_id: my_order_id,
  product_number: '123456',
  description: 'Brief product description',
  client_ip_address: '12.34.56.78',
  return_url: 'http://example.com/payex-return',
  cancel_url: 'http://example.com/payex-cancel'

# Swish example:
payment_url = PayEx::Redirect.initialize!
  price: 14900, # (in cents)
  order_id: my_order_id,
  product_number: '123456',
  description: 'Brief product description',
  client_ip_address: '12.34.56.78',
  return_url: 'http://example.com/payex-return',
  view: 'SWISH'
  cancel_url: 'http://example.com/payex-cancel'
```

After redirecting the customer to `payment_url`, they'll enter their
payment details and then PayEx will redirect them back to `return_url`
with a parameter called `orderRef` appended to the query string.

The `PayEx::Redirect.complete!` method takes
this `orderRef` string as input and returns your order ID as output.

```ruby
order_id, error, raw_response =
  PayEx::Redirect.complete! '9b4031c19960da92d'
case error
when nil
  # The transaction succeeded (use `order_id` to proceed).
when PayEx::Error::CardDeclined
  # The transaction was declined by the credit card company.
else
  # The transaction failed (look at `raw_response` for details).
end
```
