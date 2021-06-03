require_relative '../lib/transaction_repository'
require 'simplecov'

SimpleCov.start

RSpec.describe TransactionRepository do

  describe 'instantiation' do

    before :each do
      @tr = TransactionRepository.new('./spec/fixtures/transactions.csv')
    end

    it 'exists' do
      expect(@tr).to be_a(TransactionRepository)
    end

    it 'has readable attributes' do
      expect(@tr.all).to eq([])
    end
  end
end
