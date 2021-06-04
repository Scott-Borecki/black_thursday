require_relative 'invoice_item'

class InvoiceItemRepository
  attr_reader :all

  def initialize(path)
    @all = []
    populate_repository(path)
  end

  def find_by_id(id)
    all.find { |invoice| id == invoice.id }
  end

  def find_all_by_item_id(id)
    all.find_all { |invoice| id == invoice.item_id }
  end

  def populate_repository(path)
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      data_hash = {
        id:          row[:id].to_i,
        item_id:     row[:item_id].to_i,
        invoice_id:  row[:invoice_id].to_i,
        quantity:    row[:quantity].to_i,
        unit_price:  BigDecimal(row[:unit_price]) / 100,
        created_at:  Time.parse(row[:created_at]),
        updated_at:  Time.parse(row[:updated_at])
      }
      @all << InvoiceItem.new(data_hash)
    end
  end

  def inspect
   "#<#{self.class} #{@invoice_items.size} rows>"
  end
end
