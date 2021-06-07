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
    invoices.all.reduce([]) do |array, invoice|
      merchant = merchants.find_by_id(invoice.merchant_id)
      array << merchant unless successful_transaction?(invoice.id)
      array
    end.uniq
  end

  def merchants_with_only_one_item
    merchants.all.find_all do |merchant|
      items.find_all_by_merchant_id(merchant.id).count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    # # convert month input to first three letters
    # month_abb = month[0..2]
    # m = Time.new(2021, month_abb).month
    #
    # merchant.created_at.month
    #
    # items.all.reduce([]) do |ddddddd|
    #   merchant =
    #   one_item_registered_in_month =
    #   array << merchant if one_item_registered_in_month
    #   array
    # end
  end

  def revenue_by_merchant
    # find all successful transactions for merchant and sum.
    # merchant id is not in transactions, so need to find all invoices related to merchant id first.
    # the unit price is not shown on the invoice or transaction,
    # so need to calculate the amount on the invoice item with quantity and unit_price for each invoice item on the invoice
    #
    # find all invoice ids by merchant id ... then find all successful transactions for invoice ids ... then for each invoice id, and sum
  end

end
