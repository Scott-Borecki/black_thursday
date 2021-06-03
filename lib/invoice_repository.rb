require 'CSV'
require_relative '../lib/invoice'
require 'time'

class InvoiceRepository
  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
  end

  def inspect
   "#<#{self.class} #{@invoices.size} rows>"
  end

  def find_by_id(id)
    all.find { |invoice| id == invoice.id }
  end

  def find_by_customer_id(customer_id)
    all.find_all { |invoice| customer_id == invoice.customer_id}
  end

  def find_all_by_merchant_id(merchant_id)
    all.find_all { |invoice| merchant_id == invoice.merchant_id }
  end 

  def find_all_by_status(status)
    all.find_all { |invoice| status.downcase == invoice.status.downcase }
  end 









  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:           row[:id].to_i,
        customer_id:  row[:customer_id].to_i,
        merchant_id:  row[:merchant_id].to_i,
        status:       row[:status],
        created_at:   Time.parse(row[:created_at]),
        updated_at:   Time.parse(row[:updated_at])
      }
      @all << Invoice.new(data_hash)
    end

    def inspect
      "#<#{self.class} #{@invoices.size} rows>"
     end
  end


end
