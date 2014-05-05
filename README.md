# PayEx

Ruby implementation of the [PayEx](http://pim.payex.com/section3/section3_4_2.htm) API.

## Installation

`[sudo] gem install payex`

## Usage

### Initialize PayEx

``` ruby
require "payex"

PayEx.default_currency = "SEK"
PayEx.account_number   = 12345678
PayEx.encryption_key   = "TOP-SECRET"
PayEx.base_url         = PayEx::TEST_URL # or PayEx::LIVE_URL
```

### Create a redirect url

``` ruby
local_order_id = "c704acc45a4bec4c8cd50b73fb01a7c7"
price          = 100 # SEK

payment_url = PayEx::CreditCardRedirect.initialize_transaction!({
  product_number: "123456",
  order_id: local_order_id,
  product_description: "Brief product description",
  price: (price * 100).to_i,
  customer_ip: "12.34.56.78",
  return_url: "http://example.com/payex-return",
  cancel_url: "http://example.com/payex-cancel"
})

# Redirect user to payment_url
```

### Verifing `orderRef`

After sending the customer to `payment_url`, they will enter their
payment details before being redirected back to `return_url`
with an `orderRef` parameter appended to the query string.
`http://example.com/payex-return?orderRef=9b4031c19960da92d`
By giving the `orderRef` value to `PayEx.complete_transaction!` you
retreive your local order ID and your app can proceed from there.

``` ruby
begin
  local_order_id, error, response = 
    PayEx::CreditCardRedirect.complete_transaction!(order_ref)
  # Transaction successful
rescue PayEx::Error => error
  # transaction unsucessful
end
```