require 'CSV'
require_relative '../lib/item_repository'
require_relative '../lib/merchant_repository'


class SalesEngine
  attr_reader :items,
              :merchants

  def initialize(data_hash)
    @items     = ItemRepository.new(data_hash[:items])
    @merchants = MerchantRepository.new(data_hash[:merchants])
  end

  def self.from_csv(data_hash)
    SalesEngine.new(data_hash)
  end
end
