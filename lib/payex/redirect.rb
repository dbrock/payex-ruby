module PayEx::Redirect
  extend self

  def initialize!(params)
    response = PayEx::PxOrder.Initialize8(
      accountNumber: params[:account_number],
      purchaseOperation: params[:purchase_operation],
      price: params[:price],
      priceArgList: params[:price_arg_list],
      currency: params[:currency],
      vat: params[:vat],
      orderID: params[:order_id],
      productNumber: params[:product_number],
      description: params[:description],
      clientIPAddress: params[:client_ip_address],
      clientIdentifier: params[:client_identifier],
      additionalValues: params[:additional_values],
      externalID: params[:external_id],
      returnUrl: params[:return_url],
      view: params[:view],
      agreementRef: params[:agreement_ref],
      cancelUrl: params[:cancel_url],
      clientLanguage: params[:client_language]
    )
    response[:redirect_url]
  end

  def complete!(id)
    response = PayEx::PxOrder.Complete(orderRef: id)

    status = response[:transaction_status]
    status = PayEx::API.parse_transaction_status(status)

    case status
    when :sale, :authorize
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
