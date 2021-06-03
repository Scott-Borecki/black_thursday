class InvoiceItemRepository

  def initialize(path)
    @all = []
    # populate_repository(path)
  end

  def inspect
   "#<#{self.class} #{@invoice_items.size} rows>"
  end
end
