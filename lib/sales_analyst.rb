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

  def total_num_invoices
    @sales_engine.invoices.all.uniq.count
  end 

  def average_invoices_per_merchant
    total_num_invoices.fdiv(total_num_merchants).round(2)
  end 

  def average_invoices_per_merchant_standard_deviation
    num_invoices_per_merchant = @sales_engine.merchants.all.map do |merchant|
      @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count
    end 
    std_dev(num_invoices_per_merchant)
  end 

  def num_of_invoices_by_merchant(id)
    @sales_engine.invoices.find_all_by_merchant_id(id).count
  end

  def top_merchants_by_invoice_count
    mean = total_num_invoices.fdiv(total_num_merchants).round(2)
    num_invoices = @sales_engine.merchants.all.map do |merchant|
      @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count
    end
    require "pry"; binding.pry
    inv_std_dev = std_dev(num_invoices)
    two_devs = mean + (inv_std_dev * 2)
    @sales_engine.merchants.all.reduce([]) do |array, merchant|
      array << merchant if @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count > two_devs
      array
    end
  end 

  def bottom_merchants_by_invoice_count
    mean = total_num_invoices.fdiv(total_num_merchants).round(2)
    num_invoices = @sales_engine.merchants.all.map do |merchant|
      @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count
    end

    inv_std_dev = std_dev(num_invoices)
    two_devs = mean - (inv_std_dev * 2)
    @sales_engine.merchants.all.reduce([]) do |array, merchant|
      array << merchant if @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count < two_devs
      array
    end
  end 

  def weekday(date)
    date.strftime("%A")
  end 

  def count_days(day)
    @sales_engine.invoices.all.count do |invoice| 
     weekday(invoice.created_at) == day
    end
  end 
  
  def top_days_by_invoice_count
    mean = total_num_invoices.fdiv(7).round(2)
    days = {}
    @sales_engine.invoices.all.each do |invoice| 
      days[count_days(weekday(invoice.created_at))] = weekday(invoice.created_at)
    end 
    nums = days.keys
    days_std_dev = std_dev(nums)
    one_std_dev = mean + days_std_dev
    days_with_invoice = []
    days.find_all do |invoice_count, day|
      if invoice_count > one_std_dev
        days_with_invoice << day
      end
    end 
    days_with_invoice
  end 
end