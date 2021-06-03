class InvoiceRepository

  def initialize(path)
    @all = []
    # populate_repository(path)
  end

  def inspect
   "#<#{self.class} #{@invoices.size} rows>"
  end
end
