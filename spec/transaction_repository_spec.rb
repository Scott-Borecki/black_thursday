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
  end
end
