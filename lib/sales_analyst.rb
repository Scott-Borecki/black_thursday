class SalesAnalyst

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def average_items_per_merchant
    total_num_items.fdiv(total_num_merchants).round(2)
  end

  def total_num_items
    @sales_engine.items.all.uniq.count
  end

  def total_num_merchants
    @sales_engine.merchants.all.uniq.count
  end

  def average(numbers)
    numbers.sum.fdiv(numbers.count)
  end

  def std_dev(numbers)
    numerator = numbers.reduce(0) do |sum, number|
      sum + (number.to_f - average(numbers))**2
    end
    (numerator.fdiv(numbers.count - 1)**0.5).round(2)
  end

  def average_items_per_merchant_standard_deviation
    num_items_per_merchant = @sales_engine.merchants.all.map do |merchant|
      @sales_engine.items.find_all_by_merchant_id(merchant.id).count
    end
    std_dev(num_items_per_merchant)
  end

  # def merchants_with_pending_invoices
  #   # find all invoices with :pending status
  #     #=> return array of invoices
  #   # map over invoice array to return merchant id
  #     #=> return array of merchant IDs
  #   # uniq to delete duplicate merchant ids
  #     #=>return array of unique merchant ids
  #   # use merchants.find_by_id(merchant_id) to find each merchant object and reduce into an empty array
  #   #
  #   # merchant_ids = @sales_engine.invoices.all.map do |invoice|
  #   #   find_all_by_status(:pending).merchant_id
  #   # end.uniq
  #
  #   # merchant_ids = @sales_engine.invoices.find_all_by_status(:pending).map do |invoice|
  #   #   invoice.merchant_id
  #   # end
  #   # require "pry"; binding.pry
  #   #
  #   # merchant_ids.uniq
  #   # #
  #   # merchants = merchant_ids.map do |merchant_id|
  #   #   @sales_engine.merchants.find_by_id(merchant_id)
  #   # end
  # end

  def merchants_with_only_one_item
    @sales_engine.merchants.all.reduce([]) do |array, merchant|
      array << merchant if @sales_engine.items.find_all_by_merchant_id(merchant.id).count == 1
      array
    end
  end
end
