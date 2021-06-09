require_relative 'mathable'

class SalesAnalyst
  include Mathable
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
    items.total_num.fdiv(merchants.total_num).round(2)
  end

  def average_items_per_merchant_standard_deviation
    num_items_per_merchant = merchants.all.map do |merchant|
      items.find_all_by_merchant_id(merchant.id).count
    end
    std_dev(num_items_per_merchant)
  end

  def merchants_with_high_item_count
    merchants.all.find_all do |merchant|
      items.find_all_by_merchant_id(merchant.id).count >= average_items_per_merchant_standard_deviation + average_items_per_merchant
    end
  end

  def average_item_price_for_merchant(merchant_id)
    items.average_item_price_for_merchant(merchant_id)
  end

  def average_average_price_per_merchant
    all_merchant_averages = merchants.all.map do |merchant|
    average_item_price_for_merchant(merchant.id)
    end
    (all_merchant_averages.sum / BigDecimal(all_merchant_averages.count)).round(2)
  end

  def golden_items
    items.golden_items
  end

  def average_invoices_per_merchant
    invoices.total_num.fdiv(merchants.total_num).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    num_invoices_per_merchant = merchants.all.map do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).count
    end
    std_dev(num_invoices_per_merchant)
  end

  def num_of_invoices_by_merchant(id)
    invoices.find_all_by_merchant_id(id).count
  end

  def top_merchants_by_invoice_count
    mean = invoices.total_num.fdiv(merchants.total_num).round(2)
    num_invoices = merchants.all.map do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).count
    end

    inv_std_dev = std_dev(num_invoices)
    two_devs = mean + (inv_std_dev * 2)
    merchants.all.each_with_object([]) do |merchant, array|
      array << merchant if invoices.find_all_by_merchant_id(merchant.id).count > two_devs
    end
  end

  def bottom_merchants_by_invoice_count
    mean = invoices.total_num.fdiv(merchants.total_num).round(2)
    num_invoices = merchants.all.map do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).count
    end

    inv_std_dev = std_dev(num_invoices)
    two_devs = mean - (inv_std_dev * 2)
    merchants.all.each_with_object([]) do |merchant, array|
      array << merchant if invoices.find_all_by_merchant_id(merchant.id).count < two_devs
    end
  end

  def top_days_by_invoice_count
    invoices.top_days
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

  def revenue_by_merchant(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id).sum do |invoice|
      transactions.successful_transaction?(invoice.id) ?
        invoice_items.sum_invoice_items(invoice.id) : 0
    end
  end

  def top_revenue_earners(x = 20)
    merchants.all.max_by(x) { |merchant| revenue_by_merchant(merchant.id) }
  end

  def invoice_paid_in_full?(invoice_id)
    transact = transactions.find_all_by_invoice_id(invoice_id)
    success = transact.find_all { |transaction| transaction.result == :success }
    success.count >= 1
  end

  def invoice_total(invoice_id)
    inv_items = invoice_items.find_all_by_invoice_id(invoice_id)
    big_decimal_total = inv_items.map do |invoice|
      invoice.unit_price * invoice.quantity
    end.sum
    big_decimal_total
  end

  def total_revenue_by_date(date)
    invoices_by_date = invoices.find_all_by_date(date)

    transactions_by_invoice_id = invoices_by_date.map do |invoice|
      transactions.find_all_by_invoice_id(invoice.id)
    end

    successful_transaction_invoice_ids = transactions_by_invoice_id.flatten.reduce([]) do |results, transaction|
      results << invoice_items.find_all_by_invoice_id(transaction.invoice_id) if transaction.result == :success
    end.flatten.uniq

    successful_transaction_invoice_ids.reduce(0) do |sum, invoice_item|
      sum + invoice_item.unit_price * invoice_item.quantity
    end
  end

  def invoice_status(status)
    invoices.invoice_status(status)
  end
end

