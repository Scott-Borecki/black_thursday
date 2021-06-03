require 'CSV'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice'
require 'rspec'
require 'simplecov'

SimpleCov.start

RSpec.describe InvoiceRepository do

  before :each do
    @i = InvoiceRepository.new('./spec/fixtures/invoices.csv')
  end

  describe 'Object Creation' do

    it 'exists' do 
      expect(@i).to be_a(InvoiceRepository)
    end 

    it 'has readable attributes' do 
      expect(@i.all).to be_a(Array)
      expect(@i.all.count).to eq(19)
    end 
  end 

  describe 'Object Methods' do
    
    it 'can return Invoice by ID' do 
      expect(@i.find_by_id(1).merchant_id).to eq(12335938)
      expect(@i.find_by_id(100000000000)).to eq(nil)
    end 

    
  end 

end
