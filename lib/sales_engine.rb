require 'CSV'
require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'
require_relative 'sales_analyst'


class SalesEngine
  attr_reader :items,
              :merchants,
              :invoices,
              :invoice_items,
              :transactions,
              :customers,
              :analyst

  def initialize(data_hash)
    @items         = ItemRepository.new(data_hash[:items])
    @merchants     = MerchantRepository.new(data_hash[:merchants])
    @invoices      = InvoiceRepository.new(data_hash[:invoices])
    @invoice_items = InvoiceItemRepository.new(data_hash[:invoice_items])
    @transactions  = TransactionRepository.new(data_hash[:transactions])
    @customers     = CustomerRepository.new(data_hash[:customers])
    @analyst       = SalesAnalyst.new(self)
  end

  def self.from_csv(data_hash)
    SalesEngine.new(data_hash)
  end
end
