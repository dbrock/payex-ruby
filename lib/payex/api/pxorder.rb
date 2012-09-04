module PayEx::API::PxOrder
  extend self

  def wsdl
    '%s/pxorder/pxorder.asmx?WSDL' % PayEx.base_url
  end

  def Initialize8(params)
    PayEx::API.invoke! wsdl, 'Initialize8', params, {
      'accountNumber' => {
        signed: true,
        default: proc { PayEx.account_number! }
      },
      'purchaseOperation' => {
        signed: true,
        default: 'SALE'
      },
      'price' => {
        signed: true,
        format: Integer
      },
      'currency' => {
        signed: true,
        default: proc { PayEx.default_currency }
      },
      'vat' => {
        signed: true,
        format: Integer,
        default: 0
      },
      'orderID' => {
        signed: true,
        format: /^[a-z0-9]{,50}$/i
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
      },
      'cancelUrl' => {
        signed: true,
        default: nil
      }
    }
  end

  def Complete(params)
    PayEx::API.invoke! wsdl, 'Complete', params, {
      'accountNumber' => {
        signed: true,
        default: proc { PayEx.account_number! }
      },
      'orderRef' => {
        signed: true
      }
    }
  end
end
