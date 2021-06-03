class CustomerRepository

  def initialize(path)
    @all = []
    # populate_repository(path)
  end

  def inspect
   "#<#{self.class} #{@customers.size} rows>"
  end
end
