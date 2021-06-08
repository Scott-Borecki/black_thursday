class SalesAnalyst
  attr_reader :merchants,
              :items,
              :customers,
              :invoices,
              :invoice_items,
              :transactions

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @merchants = sales_engine.merchants
    @items = sales_engine.items
    @customers = sales_engine.customers
    @invoices = sales_engine.invoices
    @invoice_items = sales_engine.invoice_items
    @transactions = sales_engine.transactions
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
    num_items_per_merchant = merchants.all.map do |merchant|
      items.find_all_by_merchant_id(merchant.id).count
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

  def average_average_price_per_merchant
    all_merchant_averages = @sales_engine.merchants.all.map do |merchant|
    average_item_price_for_merchant(merchant.id)
    end
    (all_merchant_averages.sum / BigDecimal(all_merchant_averages.count)).round(2)
  end

  def golden_items
    num_items = @sales_engine.items.all.map do |item|
      item.unit_price
    end
    mean = num_items.sum.fdiv(num_items.count).round(2)
    item_std_dev = std_dev(num_items)
    two_devs = mean + (item_std_dev * 2)
    @sales_engine.items.all.reduce([]) do |array, item|
      array << item if item.unit_price > two_devs
      array
    end
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

    inv_std_dev = std_dev(num_invoices)
    two_devs = mean + (inv_std_dev * 2)
    @sales_engine.merchants.all.each_with_object([]) do |merchant, array|
      array << merchant if @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count > two_devs
    end
  end

  def bottom_merchants_by_invoice_count
    mean = total_num_invoices.fdiv(total_num_merchants).round(2)
    num_invoices = @sales_engine.merchants.all.map do |merchant|
      @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count
    end

    inv_std_dev = std_dev(num_invoices)
    two_devs = mean - (inv_std_dev * 2)
    @sales_engine.merchants.all.each_with_object([]) do |merchant, array|
      array << merchant if @sales_engine.invoices.find_all_by_merchant_id(merchant.id).count < two_devs
    end
  end

  def weekday(date)
    date.strftime('%A')
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
      days_with_invoice << day if invoice_count > one_std_dev
    end
    days_with_invoice
  end

  def successful_transaction?(invoice_id)
    transactions.find_all_by_invoice_id(invoice_id).any? do |transaction|
      transaction.result == :success
    end
  end

  def merchants_with_pending_invoices
    invoices.all.each_with_object([]) do |invoice, array|
      merchant = merchants.find_by_id(invoice.merchant_id)
      array << merchant unless successful_transaction?(invoice.id)
    end.uniq
  end

  def merchants_with_only_one_item
    merchants.all.find_all do |merchant|
      items.find_all_by_merchant_id(merchant.id).count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    # convert month input to first three letters
    month_abb = month[0..2]
    month_integer = Time.new(2021, month_abb).month

    # merchants.all.find_all do |merchant|
    #   count = invoices.find_all_by_merchant_id(merchant.id).count do |invoice|
    #     invoice.created_at.month == month_integer
    #   end
    #   merchant.created_at.month == month_integer &&
    #     count == 1
    # end

    # invoice_items.all.reduce([]) do |array, invoice_item|
    #   array << merchants.find_by_id(invoices.find_by_id(invoice_item.invoice_id).merchant_id) if
    #     merchants.find_by_id(invoices.find_by_id(invoice_item.invoice_id).merchant_id).created_at.month == month_integer &&
    #       invoices.find_by_id(invoice_item.invoice_id).created_at.month == month_integer &&
    #         invoice_items.find_all_by_invoice_id(invoice_item.invoice_id).count == 1
    #   array
    # end     #=> Array with 10 elements

    # TRY ONLY ONE INVOICE IN GIVEN MONTH
    # invoices.all.reduce([]) do |array, invoice|
    #   array << merchants.find_by_id(invoice.merchant_id) if
    #     invoice.created_at.month == month_integer &&
    #       invoices.all.find_all do |invoice2|
    #         month_integer == invoice.created_at.month &&
    #           invoice.merchant_id == invoice2.merchant_id
    #       end.count == 1
    #   array
    # end     #=> Array with 0 elements

    # TRIED TO TAKE OUT REQUIREMENT OF MERCHANT CREATED DATE TO MATCH MONTH
    # invoice_items.all.reduce([]) do |array, invoice_item|
    #   array << merchants.find_by_id(invoices.find_by_id(invoice_item.invoice_id).merchant_id) if
    #     invoices.find_by_id(invoice_item.invoice_id).created_at.month == month_integer &&
    #       invoice_items.find_all_by_invoice_id(invoice_item.invoice_id).count == 1
    #   array
    # end   #=> Array with 60 elements

    # WRONG
    # items.all.reduce([]) do |array, item|
    #   array << merchants.find_by_id(item.merchant_id) if
    #     merchants.find_by_id(item.merchant_id).created_at.month == month_integer &&
    #       item.created_at.month == month_integer &&
    #         items.find_all_by_merchant_id(item.merchant_id).count == 1
    #   array
    # end
  end

  def revenue_by_merchant(merchant_id)
    # invoices.find_all_by_merchant_id(merchant_id).reduce(0) do |sum, invoice|
    #   if successful_transaction?(invoice.id)
    #     sum = invoice_items.find_all_by_invoice_id(invoice.id).sum do |invoice_item|
    #       invoice_item.unit_price * invoice_item.quantity
    #     end
    #     sum
    #   end
    # end

    invoices.find_all_by_merchant_id(merchant_id).sum do |invoice|
      if successful_transaction?(invoice.id) == false
        0
      else
        invoice_items.find_all_by_invoice_id(invoice.id).sum do |invoice_item|
          invoice_item.unit_price * invoice_item.quantity
        end
      end
    end
  end

  def top_revenue_earners(x = 20)
    merchants.all.max_by(x) { |merchant| revenue_by_merchant(merchant.id) }
  end

  def invoice_status(status)
    status_count = @sales_engine.invoices.find_all_by_status(status).count
    total_count = @sales_engine.invoices.all.count
    (status_count.to_f / total_count * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    transactions = @sales_engine.transactions.find_all_by_invoice_id(invoice_id)
    success = transactions.find_all { |transaction| transaction.result == :success }
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
      sum + invoice_item.unit_price * invoice_item.quantity
    end
  end
end
