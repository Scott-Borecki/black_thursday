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

  def merchants_with_high_item_count
    @sales_engine.merchants.all.find_all do |merchant|
      @sales_engine.items.find_all_by_merchant_id(merchant.id).count >= average_items_per_merchant_standard_deviation + average_items_per_merchant
    end
  end

  def average_item_price_for_merchant(merchant_id)
    item_prices = @sales_engine.items.find_all_by_merchant_id(merchant_id).map do |item|
      item.unit_price
    end
    (item_prices.sum / BigDecimal(item_prices.count)).round(2)
  end
end
