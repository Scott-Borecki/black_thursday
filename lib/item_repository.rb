require 'CSV'
require_relative '../lib/item'
require 'bigdecimal'
require 'time'
require_relative 'mathable'

class ItemRepository
  include Mathable
  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
  end

  def find_by_id(id)
    all.find { |item| id == item.id }
  end

  def find_by_name(name)
    all.find { |item| name.downcase == item.name.downcase }
  end

  def find_all_with_description(description)
    all.find_all { |item| description.downcase == item.description.downcase }
  end

  def find_all_by_price(price)
    all.find_all { |item| price == item.unit_price }
  end

  def find_all_by_price_in_range(range)
    all.find_all { |item| range.include?(item.unit_price) }
  end

  def find_all_by_merchant_id(merchant_id)
    all.find_all { |item| merchant_id == item.merchant_id }
  end

  # def find_all_by_merchant_id(merchant_id)
  #   merchant_ids[merchant_id]
  # end
  #
  # def merchant_ids
  #   all.group_by { |item| item.merchant_id }
  # end

  def create(attributes)
    new_id = all.max_by { |item| item.id }.id + 1
    attributes[:id] = new_id
    all << Item.new(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    item = find_by_id(id)
    all.delete(item)
  end

  def sum_item_prices(merchant_id)
    find_all_by_merchant_id(merchant_id).sum { |item| item.unit_price }
  end

  def average_item_price_for_merchant(merchant_id)
    (sum_item_prices(merchant_id) / BigDecimal(find_all_by_merchant_id(merchant_id).count)).round(2)
  end

  def total_num
    all.uniq.count
  end

  def golden_items
    num_items = all.map do |item|
      item.unit_price
    end
    mean = num_items.sum.fdiv(num_items.count).round(2)
    item_std_dev = std_dev(num_items)
    two_devs = mean + (item_std_dev * 2)
    all.reduce([]) do |array, item|
      array << item if item.unit_price > two_devs
      array
    end
  end

  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:          row[:id].to_i,
        name:        row[:name],
        description: row[:description],
        unit_price:  BigDecimal(row[:unit_price]) / 100,
        created_at:  Time.parse(row[:created_at]),
        updated_at:  Time.parse(row[:updated_at]),
        merchant_id: row[:merchant_id].to_i
      }
      @all << Item.new(data_hash)
    end
  end

  def inspect
   "#<#{self.class} #{@items.size} rows>"
  end
end
