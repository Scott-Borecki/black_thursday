class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at

  def initialize(data_hash)
    @id         = data_hash[:id]
    @item_id    = data_hash[:item_id]
    @invoice_id = data_hash[:invoice_id]
    @quantity   = data_hash[:quantity]
    @unit_price = data_hash[:unit_price]
    @created_at = data_hash[:created_at]
    @updated_at = data_hash[:updated_at]
  end

  def unit_price_to_dollars
    unit_price.to_f.round(2)
  end

  def update(attributes)
    attributes[:updated_at] = Time.now
    @quantity   = attributes[:quantity] || @quantity
    @unit_price = attributes[:unit_price] || @unit_price
    @updated_at = attributes[:updated_at]
  end
end
