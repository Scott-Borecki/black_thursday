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
      expect(@sales_analyst).to be_an_instance_of(SalesAnalyst)
    end

    it 'has readable attributes' do
      expect(@sales_analyst.merchants).to be_an_instance_of(MerchantRepository)
      expect(@sales_analyst.items).to be_an_instance_of(ItemRepository)
      expect(@sales_analyst.customers).to be_an_instance_of(CustomerRepository)
      expect(@sales_analyst.invoices).to be_an_instance_of(InvoiceRepository)
      expect(@sales_analyst.invoice_items).to be_an_instance_of(InvoiceItemRepository)
      expect(@sales_analyst.transactions).to be_an_instance_of(TransactionRepository)
    end
  end

  describe 'Object Methods' do

    it 'can return the average items per merchant' do
      expect(@sales_analyst.average_items_per_merchant).to eq(2.88)
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

    it 'can return merchants with high item count' do
      expect(@sales_analyst.merchants_with_high_item_count.count).to eq(52)
    end

    it 'can return average item price per merchant' do
      expect(@sales_analyst.average_item_price_for_merchant(12334105)).to eq(16.66)
    end

    it 'can return the average average price per merchant' do
      expect(@sales_analyst.average_average_price_per_merchant).to eq(350.29)
    end

    it 'can return "Golden Items" 2 standard deviations above average price' do
      expect(@sales_analyst.golden_items.length).to eq(5)
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

    it 'can return the percentage of invoices based on status' do
      expect(@sales_analyst.invoice_status(:pending)).to eq(29.55)
      expect(@sales_analyst.invoice_status(:shipped)).to eq(56.95)
      expect(@sales_analyst.invoice_status(:returned)).to eq(13.5)
    end

    it 'can identify if an invoice is paid in full' do
      expect(@sales_analyst.invoice_paid_in_full?(2179)).to eq(true)
    end

    it 'can return the total dollar amount of an invoice' do
      expect(@sales_analyst.invoice_total(2179)).to eq(0.3107511e5)
    end

    it 'can return the total revenue by date' do
      date = Time.parse("2009-02-07")
      expect(@sales_analyst.total_revenue_by_date(date)).to eq(0.2106777e5)
    end

    it 'can return the total number of invoices' do
      expect(@sales_analyst.total_num_invoices).to eq(4985)
    end

    it 'can return average invoices per merchant' do
      expect(@sales_analyst.average_invoices_per_merchant).to eq(10.49)
    end

    it 'can return average invoices by merchant standard deviation' do
      expect(@sales_analyst.average_invoices_per_merchant_standard_deviation).to eq(3.29)
    end

    it 'can return top merchants by invoice count' do
      expect(@sales_analyst.top_merchants_by_invoice_count.count).to eq(12)
    end

    it 'can return bottom merchants by invoice count' do
      expect(@sales_analyst.bottom_merchants_by_invoice_count.count).to eq(4)
    end

    it 'can return top days by invoice count' do
      expect(@sales_analyst.top_days_by_invoice_count.first).to eq('Wednesday')
    end
  end
end
