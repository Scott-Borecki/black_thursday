require './lib/invoice'
require 'rspec'
require 'time'
require 'simplecov'

SimpleCov.start

RSpec.describe Invoice do
  before :each do
    @i = Invoice.new(
      id:            6,
      customer_id:   7,
      merchant_id:   8,
      status:        'pending',
      created_at:    Time.now,
      updated_at:    Time.now
    )
  end 

  describe 'Object Creation' do 
    it 'exists' do
      expect(@i).to be_a(Invoice)
    end

    it 'has readable attributes' do
      expect(@i.id).to eq(6)
      expect(@i.customer_id).to eq(7)
      expect(@i.merchant_id).to eq(8)
      expect(@i.status).to eq('pending')
      expect(@i.created_at).to be_a(Time)
      expect(@i.updated_at).to be_a(Time)
    end
  end 
end
