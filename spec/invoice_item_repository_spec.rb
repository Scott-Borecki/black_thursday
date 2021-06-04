require 'CSV'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/item'
require_relative '../lib/invoice_item'
require 'rspec'
require 'simplecov'
require 'bigdecimal'

SimpleCov.start

RSpec.describe InvoiceItemRepository do

  before :each do
    @iir = InvoiceItemRepository.new('./spec/fixtures/invoice_item_repository.csv')
  end

  describe 'Instantiation' do

    it 'exists' do
      expect(@iir).to be_a(InvoiceItemRepository)
    end

    it 'has readable attributes' do
      expect(@iir.all).to be_a(Array)
      expect(@iir.all.count).to eq(10)
    end
  end
end
