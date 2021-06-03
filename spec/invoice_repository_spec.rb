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

    it 'can return all Invoices by customer ID' do 
      invoices = @i.find_by_customer_id(1)
      expect(invoices[0].merchant_id).to eq(12335938)
      expect(invoices.count).to eq(8)
      expect(@i.find_by_customer_id(100000000000)).to eq([])
    end

    it 'can return all Invoices by merchant ID' do 
      invoices = @i.find_all_by_merchant_id(12335938)
      expect(invoices[0].customer_id).to eq(1)
      expect(@i.find_all_by_merchant_id(420000000000)).to eq([])
    end

    it 'can return all Invoices by status' do 
      invoices = @i.find_all_by_status("peNding")
      expect(invoices.count).to eq(9)
      expect(@i.find_all_by_status("squirrels")).to eq ([])
    end

    it 'can create a new Invoice with attributes' do 
      attributes = {
        customer_id:  42000000,
        merchant_id:  42000001,
        status:       "pending",
        created_at:   Time.now,
        updated_at:   Time.now
      }
      @i.create(attributes)
      i1 = @i.all.last

      expect(@i.all.count).to eq(20)
      expect(i1.customer_id).to eq(42000000)
    end

    it 'can update Invoice Id and attributes' do
      attributes = {
        status: "shipped"
      }

      @i.update(1, attributes)
      invoice = @i.all.find_by_id(1)

      expect(invoice.status).to eq("shipped")
    end 

    it 'can delete Invoice by ID' do 
      expect(@i.all.count).to eq(19)
      @i.delete(1)
      expect(@i.all.count).to eq(18)
    end


    











  end 

end
