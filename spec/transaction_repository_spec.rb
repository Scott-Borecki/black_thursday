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
      expect(@tr.find_all_by_credit_card_number(4_068_631_943_231_473).length).to eq(2)
      expect(@tr.find_all_by_credit_card_number(4_000_000_000_000_000)).to eq([])
    end

    it 'can return all Transactions by result status' do
      expect(@tr.find_all_by_result('failed').length).to eq(1)
      expect(@tr.find_all_by_result('success').length).to eq(6)
    end
  end
end
