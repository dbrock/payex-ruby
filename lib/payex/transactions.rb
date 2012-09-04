def PayEx.authorize_transaction! order_id, params
  response = PayEx::API::PxOrder.Initialize7 \
    orderID: order_id,
    purchaseOperation: 'AUTHORIZATION',
    productNumber: params[:product_number],
    description: params[:product_description],
    price: params[:price],
    clientIPAddress: params[:customer_ip],
    returnUrl: PayEx.return_url,
    cancelUrl: PayEx.cancel_url

  response[:redirect_url]
end

def PayEx.complete_transaction! id
  response = PayEx::API::PxOrder.Complete(orderRef: id)

  status = response[:transaction_status]
  status = PayEx.parse_transaction_status(status)

  case status
  when :sale, :authorize
    response[:order_id]
  when :initialize
    raise PayEx::Error, 'Transaction not completed'
  when :failure
    message = response[:error_details][:third_party_error] rescue nil
    raise PayEx::Error, message
  else
    raise PayEx::Error, 'Unexpected transaction status: ' +
      status.to_s.upcase
  end
end

def PayEx.parse_transaction_status(status)
  case status.to_s
  when '0' then :sale
  when '1' then :initialize
  when '2' then :credit
  when '3' then :authorize
  when '4' then :cancel
  when '5' then :failure
  when '6' then :capture
  else status.to_s
  end
end
