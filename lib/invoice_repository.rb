class InvoiceRepository

  def initialize(path)
    @all = []
    # populate_repository(path)
  end

  def inspect
   "#<#{self.class} #{@invoices.size} rows>"
  end

  def find_all_by_id(id)
    all.find { |item| id == item.id }
  end

  # def find_by_custumer_id(id)
  #   all.find { |invoice|  }
  # end



end
