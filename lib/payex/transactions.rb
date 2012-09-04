def PayEx.initialize_transaction! params
  response = PayEx::API::PxOrder.Initialize8 \
    orderID: params[:order_id],
    clientIPAddress: params[:ip],
    productNumber: params[:product_id],
    description: params[:description],
    price: params[:price],
    returnUrl: params[:callback],
    cancelUrl: params[:cancel_callback]

  {
    id: response[:order_ref],
    href: response[:redirect_url]
  }
end

def PayEx.complete_transaction! id
  response = PayEx::API::PxOrder.Complete(orderRef: id)

  status = response[:transaction_status]
  status = PayEx.parse_transaction_status(status)

  {
    id: response[:transaction_number],
    status: status
  }
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
