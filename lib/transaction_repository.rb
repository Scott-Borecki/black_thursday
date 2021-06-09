require 'CSV'
require_relative '../lib/transaction'
require 'time'

class TransactionRepository

  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
    @by_invoice = transactions_by_invoice_id
  end

  def find_by_id(id)
    all.find { |transaction| id == transaction.id }
  end

  def transactions_by_invoice_id
    all.group_by { |transaction| transaction.invoice_id }
  end

  def find_all_by_invoice_id(invoice_id)
    @by_invoice[invoice_id] || []
  end

  def find_all_by_credit_card_number(credit_card_number)
    all.find_all do |transaction|
      credit_card_number == transaction.credit_card_number
    end
  end

  def find_all_by_result(result)
    all.find_all { |transaction| result == transaction.result }
  end

  def create(attributes)
    new_id = all.max_by { |transaction| transaction.id }.id + 1
    attributes[:id] = new_id
    all << Transaction.new(attributes)
  end

  def update(id, attributes)
    find_by_id(id)&.update(attributes)
  end

  def delete(id)
    transaction = find_by_id(id)
    all.delete(transaction)
  end

  def invoice_paid_in_full?(invoice_id)
    find_all_by_invoice_id(invoice_id).any? do |transaction|
      transaction.result == :success
    end
  end

  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:                          row[:id].to_i,
        invoice_id:                  row[:invoice_id].to_i,
        credit_card_number:          row[:credit_card_number],
        credit_card_expiration_date: row[:credit_card_expiration_date],
        result:                      row[:result].to_sym,
        created_at:                  Time.parse(row[:created_at]),
        updated_at:                  Time.parse(row[:updated_at])
      }
      @all << Transaction.new(data_hash)
    end
  end

  def inspect
   "#<#{self.class} #{@transactions.size} rows>"
  end
end
