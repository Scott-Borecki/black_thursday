class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at

  def initialize(data_hash)
    @id          = data_hash[:id]
    @name        = data_hash[:name]
    @created_at  = data_hash[:created_at]
    @updated_at  = data_hash[:updated_at]
  end

  def update(attributes)
    attributes[:updated_at] = Time.now
    @name       = attributes[:name]
    @updated_at = attributes[:updated_at]
  end
end
