require 'rspec'
require 'simplecov'
require 'time'
require_relative '../lib/customer'

SimpleCov.start

RSpec.describe Customer do

  before :each do
    @c = Customer.new(
      id:         6,
      first_name: 'Joan',
      last_name:  'Clarke',
      created_at: Time.now,
      updated_at: Time.now
    )
  end

  describe 'Object Creation' do

    it 'exists' do
      expect(@c).to be_a(Customer)
    end

    it 'has readable attributes' do
      expect(@c.id).to eq(6)
      expect(@c.first_name).to eq('Joan')
      expect(@c.last_name).to eq('Clarke')
      expect(@c.created_at).to be_a(Time)
      expect(@c.updated_at).to be_a(Time)
    end

  end

  describe 'Object Methods' do

    it 'can update the Customer with provided attributes' do
      attributes = {
        first_name: 'Steve',
        last_name:  'Irwin',
      }

      intitial_update_time = @c.updated_at
      @c.update(attributes)

      expect(@c.id).to eq(6)
      expect(@c.first_name).to eq('Steve')
      expect(@c.last_name).to eq('Irwin')
      expect(@c.updated_at).to be_a(Time)
      expect(@c.updated_at).not_to eq(intitial_update_time)

      attributes = { first_name: 'Paul'}

      intitial_update_time = @c.updated_at
      @c.update(attributes)

      expect(@c.id).to eq(6)
      expect(@c.first_name).to eq('Paul')
      expect(@c.last_name).to eq('Irwin')
      expect(@c.updated_at).to be_a(Time)
      expect(@c.updated_at).not_to eq(intitial_update_time)
    end
  end
end
