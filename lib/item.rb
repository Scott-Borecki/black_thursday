class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id

  def initialize(data_hash)
    @id          = data_hash[:id]
    @name        = data_hash[:name]
    @description = data_hash[:description]
    @unit_price  = data_hash[:unit_price]
    @created_at  = data_hash[:created_at]
    @updated_at  = data_hash[:updated_at]
    @merchant_id = data_hash[:merchant_id]
  end

  def unit_price_to_dollars
    unit_price.to_f.round(2)
  end

  def update(attributes)
    attributes[:updated_at] = Time.now
    @name        = attributes[:name]        || @name
    @description = attributes[:description] || @description
    @unit_price  = attributes[:unit_price]  || @unit_price
    @updated_at  = attributes[:updated_at]
  end
end
