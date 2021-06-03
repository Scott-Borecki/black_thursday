require 'time'

class Customer

  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at

  def initialize(data_hash)
    @id         = data_hash[:id]
    @first_name = data_hash[:first_name]
    @last_name  = data_hash[:last_name]
    @created_at = data_hash[:created_at]
    @updated_at = data_hash[:updated_at]
  end

  def update(attributes)
    attributes[:updated_at] = Time.now
    @first_name = attributes[:first_name]  || @first_name
    @last_name  = attributes[:last_name]  || @last_name
    @updated_at = attributes[:updated_at]
  end
end
