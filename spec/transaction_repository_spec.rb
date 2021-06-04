require 'CSV'
require_relative '../lib/transaction'
require_relative '../lib/transaction_repository'
require 'simplecov'

SimpleCov.start

RSpec.describe TransactionRepository do

  before :each do
    @tr = TransactionRepository.new('./spec/fixtures/transactions.csv')
  end

  describe 'instantiation' do

    it 'exists' do
      expect(@tr).to be_a(TransactionRepository)
    end

    it 'has readable attributes' do
      expect(@tr.all.length).to eq(7)
    end
  end

  describe 'methods' do

    it 'can return Transaction by id' do
      expect(@tr.find_by_id(1).invoice_id).to eq(2_179)
      expect(@tr.find_by_id(256)).to eq(nil)
    end

    it 'can return all Transactions by invoice ID' do
      expect(@tr.find_all_by_invoice_id(2_179).length).to eq(2)
      expect(@tr.find_all_by_invoice_id(124_799)).to eq([])
    end

    it 'can return all Transactions by credit card number' do
      expect(@tr.find_all_by_credit_card_number('4068631943231473').length).to eq(2)
      expect(@tr.find_all_by_credit_card_number('4000000000000000')).to eq([])
    end

    it 'can return all Transactions by result status' do
      expect(@tr.find_all_by_result(:failed).length).to eq(1)
      expect(@tr.find_all_by_result(:success).length).to eq(6)
      expect(@tr.find_all_by_result(:hmmmm)).to eq([])
    end

    it 'can create a new Item instance' do
      attributes = {
        invoice_id:                   8,
        credit_card_number:           '4_242_424_242_424_242',
        credit_card_expiration_date:  '0_220',
        result:                       'success',
        created_at:                   Time.now,
        updated_at:                   Time.now
      }

      @tr.create(attributes)
      tr_new = @tr.all.last

      expect(@tr.all.length).to eq(8)
      expect(tr_new.id).to eq(8)
      expect(tr_new.invoice_id).to eq(8)
      expect(tr_new.credit_card_number).to eq('4_242_424_242_424_242')
      expect(tr_new.credit_card_expiration_date).to eq('0_220')
      expect(tr_new.result).to eq('success')
      expect(tr_new.created_at).to be_a(Time)
      expect(tr_new.updated_at).to be_a(Time)
    end

    it 'can update Transaction instance with provided attributes' do
      attributes = {
        credit_card_number:          '400000',
        credit_card_expiration_date: '4000',
        result:                      'failed'
      }

      @tr.update(7, attributes)
      item = @tr.find_by_id(7)
      expect(item.id).to eq(7)
      expect(item.credit_card_number).to eq('400000')
      expect(item.credit_card_expiration_date).to eq('4000')
      expect(item.result).to eq('failed')
    end

    it 'can delete Transaction instance by id' do
      expect(@tr.all.count).to eq(7)
      @tr.delete(7)
      expect(@tr.all.count).to eq(6)
    end
  end
end
