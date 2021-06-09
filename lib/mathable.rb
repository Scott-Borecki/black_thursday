module Mathable
  def average(numbers)
    numbers.sum.fdiv(numbers.count)
  end

  def std_dev(numbers)
    numerator = numbers.reduce(0) do |sum, number|
      sum + (number.to_f - average(numbers))**2
    end
    (numerator.fdiv(numbers.count - 1)**0.5).round(2)
  end

  def std_dev_from_avg(numbers, std_dev_multiplier)
    average(numbers) + std_dev(numbers) * std_dev_multiplier
  end
end
