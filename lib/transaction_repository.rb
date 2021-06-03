class TransactionRepository

  attr_reader :all

  def initialize(path)
    @all = []
    # populate_repository(path)
  end

  def inspect
   "#<#{self.class} #{@transactions.size} rows>"
  end
end
