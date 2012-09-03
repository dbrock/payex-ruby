PayEx::PxOrder.define_soap_method 'Complete', {
  'accountNumber' => {
    signed: true,
    default: PayEx.account_number
  },
  'orderRef' => {
    signed: true
  }
}
