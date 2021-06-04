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
        expect(@iir.find_all_by_invoice_id(1)[0].id).to eq(1)
        expect(@iir.find_all_by_invoice_id(56)).to eq([])
      end

      it 'creates new InvoiceItem w/attributes' do
        attributes = {
          item_id:     963_519_844,
          invoice_id:  3,
          quantity:    10,
          unit_price:  BigDecimal(9.99, 4),
          created_at:  Time.now,
          updated_at:  Time.now
        }

        @iir.create(attributes)
        i11 = @iir.all.last

        expect(i11).to be_a(InvoiceItem)
        expect(@iir.all.count).to eq(11)
        expect(i11.id).to eq(11)
        expect(i11.item_id).to eq(963_519_844)
        expect(i11.invoice_id).to eq(3)
        expect(i11.quantity).to eq(10)
        expect(i11.unit_price).to eq(9.99)
        expect(i11.created_at).to be_a(Time)
        expect(i11.updated_at).to be_a(Time)
      end

      it 'can update InvoiceItem w/attributes' do
        attributes = {
          quantity:         11,
          unit_price:       BigDecimal(12.99, 3)
        }

        @iir.update(11, attributes)
        expect(@iir.id).to eq(11)
        expect(@iir.quantity).to eq(11)
        expect(@iir.unit_price).to eq(12.99)
      end
    end
  end
end
