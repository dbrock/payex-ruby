module PayEx::PxOrder
  extend self

  def wsdl
    '%s/pxorder/pxorder.asmx?WSDL' % PayEx.base_url
  end

  def Initialize8(params)
    PayEx::API.invoke! wsdl, :initialize8, params, {
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
      'priceArgList' => {
        signed: true,
        default: ''
      },
      'currency' => {
        signed: true,
        default: proc { PayEx.default_currency! }
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
      'clientIdentifier' => {
        signed: true,
        default: ''
      },
      'additionalValues' => {
        signed: true,
        default: 'RESPONSIVE=1'
      },
      'externalID' => {
        signed: true,
        default: ''
      },
      'returnUrl' => {
        signed: true
      },
      'view' => {
        signed: true,
        default: 'CREDITCARD'
      },
      'agreementRef' => {
        signed: true,
        default: ''
      },
      'cancelUrl' => {
        signed: true,
        default: ''
      },
      'clientLanguage' => {
        signed: true,
        default: ''
      }
    }
  end

  def Complete(params)
    PayEx::API.invoke! wsdl, :complete, params, {
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
