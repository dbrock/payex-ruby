def PayEx.initiate_transaction! params
  response = PayEx::API::PxOrder.Initialize8 \
    orderID: params[:order_id],
    clientIPAddress: params[:ip],
    productNumber: params[:product_id],
    description: params[:description],
    price: params[:price],
    returnUrl: params[:callback],
    cancelUrl: params[:cancel_callback]
  if ok = response[:status][:code] == 'OK' rescue false
    PayEx::Transaction.new(response[:order_ref], response[:redirect_url])
  else
    raise PayEx::Error, response[:status][:description]
  end
end

class PayEx::Transaction < Struct.new(:id, :href)
end
