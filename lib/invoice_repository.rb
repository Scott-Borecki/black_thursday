require 'CSV'
require_relative '../lib/invoice'
require 'time'
require './mathable'

class InvoiceRepository
  include Mathable

  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
  end

  def find_by_id(id)
    all.find { |invoice| id == invoice.id }
  end

  def find_all_by_customer_id(customer_id)
    all.find_all { |invoice| customer_id == invoice.customer_id }
  end

  def find_all_by_merchant_id(merchant_id)
    all.find_all { |invoice| merchant_id == invoice.merchant_id }
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

  def weekday(date)
    date.strftime('%A')
  end

  def count_days(day)
    all.count do |invoice|
      weekday(invoice.created_at) == day
    end
  end

  def top_days
    mean = total_num.fdiv(7).round(2)
    days = {}
    all.each do |invoice|
      days[count_days(weekday(invoice.created_at))] = weekday(invoice.created_at)
    end

    nums = days.keys
    days_std_dev = std_dev(nums)
    one_std_dev = mean + days_std_dev
    days_with_invoice = []
    days.find_all do |invoice_count, day|
      days_with_invoice << day if invoice_count > one_std_dev
    end
    days_with_invoice
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
