require 'rspec'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require 'simplecov'
SimpleCov.start

RSpec.describe SalesAnalyst do

  before :each do
    @data_hash = {
      items:         './data/items.csv',
      merchants:     './data/merchants.csv',
      invoices:      './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions:  './data/transactions.csv',
      customers:     './data/customers.csv'
    }
    @sales_engine = SalesEngine.from_csv(@data_hash)
  end

  describe 'Object Creation' do
    it 'exists' do
      sales_analyst = SalesAnalyst.new(@sales_engine)
      expect(sales_analyst).to be_an_instance_of(SalesAnalyst)
    end
  end

  describe 'Object Methods' do
    before :each do
      @sales_analyst = SalesAnalyst.new(@sales_engine)
    end

    it 'can return the average items per merchant' do
      expect(@sales_analyst.average_items_per_merchant).to eq(2.88)
    end
  end
end
