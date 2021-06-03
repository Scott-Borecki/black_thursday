class TransactionRepository

  def initialize(path)
    @all = []
    # populate_repository(path)
  end

  def inspect
   "#<#{self.class} #{@transactions.size} rows>"
  end
end
