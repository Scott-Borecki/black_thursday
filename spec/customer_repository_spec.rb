require 'CSV'
require_relative '../lib/customer_repository'
require_relative '../lib/customer'
require 'rspec'
require 'simplecov'
require 'bigdecimal'

SimpleCov.start

RSpec.describe CustomerRepository do
  before :each do
    @cr = CustomerRepository.new('./spec/fixtures/customers.csv')
  end

  describe 'Object Creation' do
    it 'exists' do
      expect(@cr).to be_a(CustomerRepository)
    end

    it 'has readable attributes' do
      expect(@cr.all).to be_a(Array)
    end

    it 'populates repository' do
      expect(@cr.all.count).to eq(20)
    end
  end

  describe 'Object Methods' do
    it 'can return Customer by object ID' do
      expect(@cr.find_by_id(1).first_name).to eq('Joey')
      expect(@cr.find_by_id(999_999_999)).to eq(nil)
    end

    it 'can return all Customers by first name' do
      customers = @cr.find_all_by_first_name('On')
      expect(customers.count).to eq(2)
      expect(@cr.find_all_by_first_name('Jimbo')).to eq([])
    end

    it 'can return all Customers by last name' do
      customers = @cr.find_all_by_last_name('aD')
      expect(customers.count).to eq(3)
      expect(@cr.find_all_by_last_name('Thorntonn')).to eq([])
    end

    it 'can create a new Customer instance' do
      attributes = {
        first_name:  'Steve',
        last_name:   'Irwin',
        created_at:  Time.now,
        updated_at:  Time.now
      }

      @cr.create(attributes)
      c2 = @cr.all.last

      expect(@cr.all.count).to eq(21)
      expect(c2.id).to eq(21)
      expect(c2).to be_a(Customer)
      expect(c2.first_name).to eq('Steve')
      expect(c2.last_name).to eq('Irwin')
      expect(c2.created_at).to be_a(Time)
      expect(c2.updated_at).to be_a(Time)
    end

    it 'can update Customer instance with provided attributes' do
      attributes = {
        first_name: 'Steve',
        last_name:  'Irwin',
      }

      @cr.update(1, attributes)
      customer = @cr.find_by_id(1)
      expect(customer.id).to eq(1)
      expect(customer.first_name).to eq('Steve')
      expect(customer.last_name).to eq('Irwin')
    end

    it 'can do nothing when Customer does not exist' do
      @cr.update(999_999_999, {})
    end

    it 'can delete Customer instance by id' do
      expect(@cr.all.count).to eq(20)
      @cr.delete(1)
      expect(@cr.all.count).to eq(19)
    end
  end
end
