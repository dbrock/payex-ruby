PayEx::PxOrder.define_soap_method 'Initialize8', {
  'accountNumber' => {
    signed: true,
    default: PayEx.account_number
  },
  'purchaseOperation' => {
    signed: true,
    default: 'AUTHORIZE'
  },
  'price' => {
    signed: true,
    format: Integer
  },
  'currency' => {
    signed: true,
    default: PayEx.default_currency
  },
  'vat' => {
    signed: true,
    format: Integer,
    default: 0
  },
  'orderID' => {
    signed: true,
    format: /^.{,50}$/
  },
  'productNumber' => {
    signed: true,
    format: /^[A-Z0-9]{,50}$/
  },
  'description' => {
    signed: true,
    format: /^.{,160}$/
  },
  'clientIPAddress' => {
    signed: true
  },
  'returnUrl' => {
    signed: true
  },
  'view' => {
    signed: true,
    default: 'CREDITCARD'
  }
}
