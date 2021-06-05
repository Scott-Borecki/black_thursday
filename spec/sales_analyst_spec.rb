require 'rspec'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require 'simplecov'
SimpleCov.start

RSpec.describe SalesAnalyst do

  describe 'Object Creation' do

    it 'exists' do
      sa = SalesAnalyst.new
      expect(sa).to be_an_instance_of(SalesAnalyst)
    end

  end

end
