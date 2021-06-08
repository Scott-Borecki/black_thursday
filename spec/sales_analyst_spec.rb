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
      expect(@sales_analyst.average_items_per_merchant_standard_deviation)
        .to eq(3.26)
    end

    it 'can return whether invoice had any successful transactions' do
      expect(@sales_analyst.successful_transaction?(2179)).to be true
    end

    it 'can return merchants with pending invoices' do
      expect(@sales_analyst.merchants_with_pending_invoices.count).to eq(467)
    end

    it 'can return merchants that only sell one item' do
      expect(@sales_analyst.merchants_with_only_one_item.count).to eq(243)
      expect(@sales_analyst.merchants_with_only_one_item.first.class)
        .to eq(Merchant)
    end

    it '#merchants_with_only_one_item_registered_in_month returns merchants
      with only one invoice in given month' do
      expected = @sales_analyst
                 .merchants_with_only_one_item_registered_in_month('March')

      expect(expected.length).to eq 21
      expect(expected.first.class).to eq Merchant

      expected = @sales_analyst
                 .merchants_with_only_one_item_registered_in_month('June')

      expect(expected.length).to eq 18
      expect(expected.first.class).to eq Merchant
    end

    it 'can return total revenue for a merchant' do
      expected = @sales_analyst.revenue_by_merchant(12334194)

      expect(expected).to eq BigDecimal(expected)
      expect(expected.class).to eq BigDecimal
    end

    it '#top_revenue_earners(x) returns the top x merchants ranked by
      revenue' do
      expected = @sales_analyst.top_revenue_earners(10)
      first = expected.first
      last = expected.last

      expect(expected.length).to eq 10

      expect(first.class).to eq Merchant
      expect(first.id).to eq 12334634

      expect(last.class).to eq Merchant
      expect(last.id).to eq 12335747

      expected = @sales_analyst.top_revenue_earners

      expect(expected.length).to eq 20
    end
  end
end
