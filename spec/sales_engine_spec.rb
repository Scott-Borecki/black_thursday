require 'rspec'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_engine'
require 'simplecov'
SimpleCov.start

RSpec.describe SalesEngine do

  before :each do
    @data_hash = {
      items:         './data/items.csv',
      merchants:     './data/merchants.csv',
      invoices:      './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions:  './data/transactions.csv',
      customers:     './data/customers.csv'
    }
  end

  it 'exists' do
    se = SalesEngine.new(@data_hash)
    expect(se).to be_a(SalesEngine)
  end

  it 'can receive data from a csv' do
    se = SalesEngine.from_csv(@data_hash)
    expect(se).to be_a(SalesEngine)
    expect(se.items).to be_a(ItemRepository)
    expect(se.merchants).to be_a(MerchantRepository)
    expect(se.invoices).to be_a(InvoiceRepository)
    expect(se.invoice_items).to be_a(InvoiceItemRepository)
    expect(se.transactions).to be_a(TransactionRepository)
    expect(se.customers).to be_a(CustomerRepository)
  end
end
