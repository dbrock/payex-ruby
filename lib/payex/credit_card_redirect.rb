module PayEx::CreditCardRedirect
  extend self

  def initialize_transaction! order_id, params
    response = PayEx::PxOrder.Initialize7 \
      orderID: order_id,
      purchaseOperation: 'AUTHORIZATION',
      productNumber: params[:product_number],
      description: params[:product_description],
      price: params[:price],
      clientIPAddress: params[:customer_ip],
      returnUrl: params[:return_url],
      cancelUrl: params[:cancel_url]

    response[:redirect_url]
  end

  def complete_transaction! id
    response = PayEx::PxOrder.Complete(orderRef: id)

    status = response['transaction_status']
    status = PayEx::API.parse_transaction_status(status)
    error = nil

    case status
    when :sale, :authorize
      if response[:already_completed] == 'True'
        error = 'Transaction already completed'
      end
    when :initialize
      error = 'Transaction not completed'
    when :failure
      begin
        error = response[:error_details][:third_party_error]
      rescue
        error = 'Transaction failed'
      end
    else
      error = 'Unexpected transaction status: ' + status.to_s.upcase
    end

    [response[:order_id], error, response]
  end
end
