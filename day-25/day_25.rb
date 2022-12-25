def snafu_to_decimal(snafu)
  place_value = 1
  decimal = 0
  snafu.chars.reverse.each do |char|
    if char == '-'
      decimal -= place_value
    elsif char == '='
      decimal -= place_value * 2
    else
      decimal += place_value * char.to_i
    end
    place_value *= 5
  end
  decimal
end

def decimal_to_snafu(decimal)
  return decimal.to_s if decimal <= 2

  snafu = ''

  place_value = 5**21

  # First digit (always 1 or 2)
  loop do
    break if place_value / 2 < decimal
    place_value /= 5
  end
  snafu += ((decimal + (place_value / 2)) / (place_value)).to_s

  decimal -= snafu.to_i * place_value

  # Remaining digits
  while place_value > 1
    place_value /= 5

    # Make the calculation of r below truncate towards 0, not towards negative infinity (for negative values)
    negative = false
    if decimal.negative?
      negative = true
      decimal = -decimal
    end

    r = (decimal + (place_value / 2)) / place_value

    decimal = -decimal if negative

    if negative && r == 2
      snafu += '='
      decimal += place_value * 2
    elsif negative && r == 1
      snafu += '-'
      decimal += place_value * 1
    else
      snafu += r.to_s
      decimal -= place_value * r
    end
  end

  snafu
end

sum = 0
File.foreach('input.txt', chomp: true) do |line|
  sum += snafu_to_decimal(line)
end

p decimal_to_snafu(sum)
