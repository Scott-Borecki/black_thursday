class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at

  def initialize(data_hash)
    @id                           = data_hash[:id]
    @invoice_id                   = data_hash[:invoice_id]
    @credit_card_number           = data_hash[:credit_card_number]
    @credit_card_expiration_date  = data_hash[:credit_card_expiration_date]
    @result                       = data_hash[:result]
    @created_at                   = data_hash[:created_at]
    @updated_at                   = data_hash[:updated_at]
  end

  def update(attributes)
    attributes[:updated_at] = Time.now
    @credit_card_number          = attributes[:credit_card_number]          || @credit_card_number
    @credit_card_expiration_date = attributes[:credit_card_expiration_date] || @credit_card_expiration_date
    @result                      = attributes[:result]                      || @result
    @updated_at                  = attributes[:updated_at]
  end
end
