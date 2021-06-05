require 'rspec'
require_relative '../lib/sales_engine'
require_relative '../lib/sales_analyst'
require 'simplecov'
SimpleCov.start

RSpec.describe SalesAnalyst do

  describe 'Object Creation' do
    let(:sales_engine) { "Sales Engine" }

    it 'exists' do
      sa = SalesAnalyst.new(sales_engine)
      expect(sa).to be_an_instance_of(SalesAnalyst)
    end
  end
end
