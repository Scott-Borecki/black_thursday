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
    @sales_engine  = sales_engine
    @merchants     = sales_engine.merchants
    @items         = sales_engine.items
    @customers     = sales_engine.customers
    @invoices      = sales_engine.invoices
    @invoice_items = sales_engine.invoice_items
    @transactions  = sales_engine.transactions
  end

  def average_items_per_merchant
    items.total_num.fdiv(merchants.total_num).round(2)
  end

  def average_items_per_merchant_standard_deviation
    std_dev(merchants.all.map { |merchant| items.find_all_by_merchant_id(merchant.id).length })
  end

  def num_of_items_by_merchant(id)
    items.find_all_by_merchant_id(id).length
  end

  def merchants_with_high_item_count
    one_dev_above = average_items_per_merchant_standard_deviation +
      average_items_per_merchant
    merchants.all.find_all do |merchant|
      num_of_items_by_merchant(merchant.id) >= one_dev_above
    end
  end

  def average_item_price_for_merchant(merchant_id)
    items.average_item_price_for_merchant(merchant_id)
  end

  def average_average_price_per_merchant
    all_merchant_averages = merchants.all.map do |merchant|
    average_item_price_for_merchant(merchant.id)
    end
    (all_merchant_averages.sum / BigDecimal(all_merchant_averages.length)).round(2)
    # average price of items divided by total number of merchants
  end

  def golden_items
    items.golden_items
  end

  def average_invoices_per_merchant
    invoices.total_num.fdiv(merchants.total_num).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    std_dev(merchants.all.map { |merchant| num_of_invoices_by_merchant(merchant.id) })
  end

  def num_of_invoices_by_merchant(id)
    invoices.find_all_by_merchant_id(id).length
  end

  def top_merchants_by_invoice_count
    two_devs_above = average_invoices_per_merchant +
      (average_invoices_per_merchant_standard_deviation * 2)
    merchants.all.find_all do |merchant|
      num_of_invoices_by_merchant(merchant.id) > two_devs_above
    end
  end

  def bottom_merchants_by_invoice_count
    two_devs_below = average_invoices_per_merchant -
      (average_invoices_per_merchant_standard_deviation * 2)
    merchants.all.find_all do |merchant|
      num_of_invoices_by_merchant(merchant.id) < two_devs_below
    end
  end

  def top_days_by_invoice_count
    invoices.top_days
  end

  def merchants_with_pending_invoices
    invoices.all.each_with_object([]) do |invoice, array|
      merchant = merchants.find_by_id(invoice.merchant_id)
      array << merchant unless transactions.invoice_paid_in_full?(invoice.id)
    end.uniq
  end

  def merchants_with_only_one_item
    merchants.all.find_all do |merchant|
      items.find_all_by_merchant_id(merchant.id).length == 1
    end
  end

  def revenue_by_merchant(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id).sum do |invoice|
      transactions.invoice_paid_in_full?(invoice.id) ?
        invoice_items.sum_invoice_items(invoice.id) : 0
    end
  end

  def top_revenue_earners(x = 20)
    merchants.all.max_by(x) { |merchant| revenue_by_merchant(merchant.id) }
  end

  def invoice_paid_in_full?(invoice_id)
    transactions.invoice_paid_in_full?(invoice_id)
  end

  def invoice_total(invoice_id)
    inv_items = invoice_items.find_all_by_invoice_id(invoice_id)
    inv_items.sum { |invoice| invoice.unit_price * invoice.quantity }
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
