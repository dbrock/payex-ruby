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

    status = response[:transaction_status]
    status = PayEx::API.parse_transaction_status(status)

    case status
    when :authorize
      error = nil
    when :initialize
      error = PayEx::Error.new('Transaction not completed')
    when :failure
      details = response[:error_details].inspect
      case details
      when /declined/i
        error = PayEx::Error::CardDeclined.new('Card declined')
      else
        error = PayEx::Error.new('Transaction failed')
      end
    else
      error = PayEx::Error.new('Transaction failed')
    end

    [response[:order_id], error, response]
  end
end
