require 'rspec'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require 'simplecov'
SimpleCov.start

RSpec.describe SalesAnalyst do
  before :all do
    @data_hash = {
      items:         './data/items.csv',
      merchants:     './data/merchants.csv',
      invoices:      './data/invoices.csv',
      invoice_items: './data/invoice_items.csv',
      transactions:  './data/transactions.csv',
      customers:     './data/customers.csv'
    }
    @sales_engine = SalesEngine.from_csv(@data_hash)
    @sales_analyst = SalesAnalyst.new(@sales_engine)
  end

  describe 'Object Creation' do
    it 'exists' do
      sales_analyst = SalesAnalyst.new(@sales_engine)
      expect(sales_analyst).to be_an_instance_of(SalesAnalyst)
    end
  end

  describe 'Object Methods' do

    it 'can return the average items per merchant' do
      expect(@sales_analyst.average_items_per_merchant).to eq(2.88)
    end

    it 'can return the total number of items' do
      expect(@sales_analyst.total_num_items). to eq(1367)
    end

    it 'can return the total number of merchants' do
      expect(@sales_analyst.total_num_merchants). to eq(475)
    end

    it 'can return the average' do
      set = [3,4,5]
      expect(@sales_analyst.average(set)).to eq(4)
    end

    it 'can return the standard deviation' do
      set = [3,4,5]
      expect(@sales_analyst.std_dev(set)).to eq(1)
    end

    it 'can return average items by merchant standard deviation' do
      expect(@sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.26)
    end

    it 'can return the total number of invoices' do
      expect(@sales_analyst.total_num_invoices).to eq(0)
    end
    
    xit 'can return average invoices per merchant' do
      expect(@sales_analyst.average_invoices_per_merchant).to eq(10.49)
    end 


  end
end
