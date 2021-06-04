require          'time'
require          'CSV'
require_relative 'customer'

class CustomerRepository

  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
  end

  def find_by_id(id)
    all.find { |customer| id == customer.id }
  end

  def find_all_by_first_name(sub_string)
    all.find_all do |customer|
      customer.first_name.downcase.include? sub_string.downcase
    end
  end

  def find_all_by_last_name(sub_string)
    all.find_all do |customer|
      customer.last_name.downcase.include? sub_string.downcase
    end
  end

  def create(attributes)
    new_id = all.max_by { |customer| customer.id }.id + 1
    attributes[:id] = new_id
    all << Customer.new(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    customer = find_by_id(id)
    all.delete(customer)
  end

  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:          row[:id].to_i,
        first_name:  row[:first_name],
        last_name:   row[:last_name],
        created_at:  Time.parse(row[:created_at]),
        updated_at:  Time.parse(row[:updated_at])
      }
      @all << Customer.new(data_hash)
    end
  end

  def inspect
   "#<#{self.class} #{@customers.size} rows>"
  end
end
