require 'CSV'
require_relative '../lib/merchant'

class MerchantRepository
  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
  end

  def find_by_id(id)
    all.find { |merchant| merchant.id == id }
  end

  def find_by_name(name)
    all.find { |merchant| merchant.name.downcase == name.downcase }
  end

  def find_all_by_name(name)
    all.find_all { |merchant| merchant.name.downcase.include?(name.downcase) }
  end

  def create(attributes)
    new_id = all.max_by { |merchant| merchant.id }.id + 1
    attributes[:id] = new_id
    @all << Merchant.new(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    all.delete(find_by_id(id))
  end

  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:         row[:id].to_i,
        name:       row[:name],
        created_at: Time.parse(row[:created_at]),
        updated_at: Time.parse(row[:updated_at])
      }
      @all << Merchant.new(data_hash)
    end
  end

 def inspect
  "#<#{self.class} #{@merchants.size} rows>"
 end
end
