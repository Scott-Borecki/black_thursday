require 'CSV'
require_relative '../lib/transaction'
require 'time'

class TransactionRepository

  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
  end

  def find_by_id(id)
    all.find { |transaction| id == transaction.id }
  end

  def find_all_by_invoice_id(invoice_id)
    all.find_all { |transaction| invoice_id == transaction.invoice_id }
  end


  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:                                 row[:id].to_i,
        invoice_id:                         row[:invoice_id].to_i,
        credit_card_number:                 row[:credit_card_number].to_i,
        credit_card_number_expiration_date: row[:credit_card_number_expiration_date].to_i,
        result:                             row[:result],
        created_at:                         Time.parse(row[:created_at]),
        updated_at:                         Time.parse(row[:updated_at])
      }
      @all << Transaction.new(data_hash)
    end
  end

  def inspect
   "#<#{self.class} #{@transactions.size} rows>"
  end
end
