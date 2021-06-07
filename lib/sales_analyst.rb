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

  def merchants_with_pending_invoices
    # find all invoices with :pending status
      #=> return array of invoices
    # map over invoice array to return merchant id
      #=> return array of merchant IDs
    # uniq to delete duplicate merchant ids
      #=>return array of unique merchant ids
    # use merchants.find_by_id(merchant_id) to find each merchant object and reduce into an empty array
    #
    # merchant_ids = @sales_engine.invoices.all.map do |invoice|
    #   find_all_by_status(:pending).merchant_id
    # end.uniq

    # merchant_ids = @sales_engine.invoices.find_all_by_status(:pending).map do |invoice|
    #   invoice.merchant_id
    # end
    # require "pry"; binding.pry
    #
    # merchant_ids.uniq
    # #
    # merchants = merchant_ids.map do |merchant_id|
    #   @sales_engine.merchants.find_by_id(merchant_id)
    # end

    transactions.all.reduce([]) do |array, transaction|
      invoice_id = transaction.invoice_id
      merchant_id = invoices.find_by_id(invoice_id).merchant_id
      transactions_by_invoice = transactions.find_all_by_invoice_id(invoice_id)
      merchant = merchants.find_by_id(merchant_id)
      array << merchant if transactions_by_invoice.none? do |transaction_invoice|
        transaction_invoice.result == :success
      end
      array
    end
  end

  def merchants_with_only_one_item
    merchants.all.reduce([]) do |array, merchant|
      array << merchant if items.find_all_by_merchant_id(merchant.id).count == 1
      array
    end
  end

  def revenue_by_merchant
    # find all successful transactions for merchant and sum.
    # merchant id is not in transactions, so need to find all invoices related to merchant id first.
    # the unit price is not shown on the invoice or transaction, so need to calculate the amount on the invoice item with quantity and unit_price for each invoice item on the invoice
    #
    # find all invoice ids by merchant id ... then find all successful transactions for invoice ids ... then for each invoice id, and sum

  end

end
