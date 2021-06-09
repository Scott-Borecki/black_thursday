require 'CSV'
require_relative '../lib/invoice'
require 'time'
require_relative 'mathable'

class InvoiceRepository
  include Mathable

  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
    @by_merchant = invoices_by_merchant_id
  end

  def find_by_id(id)
    all.find { |invoice| id == invoice.id }
  end

  def find_all_by_customer_id(customer_id)
    all.find_all { |invoice| customer_id == invoice.customer_id }
  end

  def invoices_by_merchant_id
    all.group_by { |invoice| invoice.merchant_id }
  end

  def find_all_by_merchant_id(merchant_id)
    @by_merchant[merchant_id] || []
  end

  def find_all_by_status(status)
    all.find_all { |invoice| status.downcase == invoice.status.downcase }
  end

  def find_all_by_date(date)
    all.find_all { |invoice| date === invoice.created_at }
  end

  def create(attributes)
    new_invoice = all.max_by { |invoice| invoice.id }.id + 1
    attributes[:id] = new_invoice
    all << Invoice.new(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    item = find_by_id(id)
    all.delete(item)
  end

  def total_num
    all.uniq.count
  end

  def invoices_by_day
    all.group_by { |invoice| invoice.created_at.strftime('%A') }
  end

  def num_invoices_by_day
    invoices_by_day.transform_values { |values| values.length }
  end

  def top_days
    num_invoices_by_day.reduce([]) do |array, (day, num_invoices)|
      array << day if num_invoices > std_dev_from_avg(num_invoices_by_day.values, 1)
      array
    end
  end

  def invoice_status(status)
    status_count = find_all_by_status(status).count
    (status_count.to_f / total_num * 100).round(2)
  end

  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:           row[:id].to_i,
        customer_id:  row[:customer_id].to_i,
        merchant_id:  row[:merchant_id].to_i,
        status:       row[:status].to_sym,
        created_at:   Time.parse(row[:created_at]),
        updated_at:   Time.parse(row[:updated_at])
      }
      @all << Invoice.new(data_hash)
    end
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end
end
