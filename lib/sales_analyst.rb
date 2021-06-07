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

  def invoice_status(status)
    status_count = @sales_engine.invoices.find_all_by_status(status).count
    total_count = @sales_engine.invoices.all.count
    (status_count.to_f / total_count * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    transactions = @sales_engine.transactions.find_all_by_invoice_id(invoice_id)
    success = transactions.find_all {|transaction| transaction.result == :success}
    success.count >= 1
  end

  def invoice_total(invoice_id)
    invoice_items = @sales_engine.invoice_items.find_all_by_invoice_id(invoice_id)
    big_decimal_total = invoice_items.map do |invoice|
      invoice.unit_price * invoice.quantity
    end.sum
    big_decimal_total
  end

  def total_revenue_by_date(date)
    invoices_by_date = @sales_engine.invoices.find_all_by_date(date)

    transactions_by_invoice_id = invoices_by_date.map do |invoice|
      @sales_engine.transactions.find_all_by_invoice_id(invoice.id)
    end

    successful_transaction_invoice_ids = transactions_by_invoice_id.flatten.reduce([]) do |results, transaction|
      results << @sales_engine.invoice_items.find_all_by_invoice_id(transaction.invoice_id) if transaction.result == :success
    end.flatten.uniq

    successful_transaction_invoice_ids.reduce(0) do |sum, invoice_item|
      sum += invoice_item.unit_price * invoice_item.quantity
    end
  end
end
