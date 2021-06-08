require 'CSV'
require_relative '../lib/merchant'
require 'simplecov'
SimpleCov.start

RSpec.describe Merchant do

  before :each do
    @m = Merchant.new(
      id:          5,
      name:        'Turing School',
      created_at:  Time.now,
      updated_at:  Time.now
    )
  end

  describe 'instantiation' do
    it 'exists' do
      expect(@m).to be_a(Merchant)
    end

    it 'has attributes' do
      expect(@m.id).to eq(5)
      expect(@m.name).to eq('Turing School')
      expect(@m.created_at).to be_a(Time)
      expect(@m.updated_at).to be_a(Time)
    end
  end

  describe 'Methods' do
    it 'can update the Merchant with provided attributes' do
      attributes = { name: 'turingschool.edu' }
      intitial_update_time = @m.updated_at
      @m.update(attributes)

      expect(@m.name).to eq('turingschool.edu')
      expect(@m.updated_at).to be_a(Time)
      expect(@m.updated_at).not_to eq(intitial_update_time)
    end
  end
end
