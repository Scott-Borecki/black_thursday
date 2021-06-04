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

    describe 'Object Methods' do

      it 'finds items by id' do
        expect(@iir.find_by_id(1).invoice_id).to eq(1)
        expect(@iir.find_by_id(11)).to eq(nil)
      end

      it 'finds all by #item_id' do
        expect(@iir.find_all_by_item_id(263_454_779)[0].id).to eq(2)
        expect(@iir.find_all_by_item_id(263_454_000)).to eq([])
      end

      it 'find all by #invoice_id' do
        exect(@iir.find_all_by_invoice_id(8).id).to eq(1, 2, 3, 4, 5, 6, 7, 8)
      end
    end
  end
end
