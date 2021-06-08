class SalesAnalyst

  def initialize(sales_engine)
    @sales_engine = sales_engine
  end

  def merchants
    @sales_engine.merchants
  end

  def items
    @sales_engine.items
  end

  def customers
    @sales_engine.customers
  end

  def invoices
    @sales_engine.invoices
  end

  def invoice_items
    @sales_engine.invoice_items
  end

  def transactions
    @sales_engine.transactions
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
end
