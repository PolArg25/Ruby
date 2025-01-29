# Define a hash to map operators to the corresponding operations
OPERATIONS = {
  "+" => ->(a, b) { a + b },
  "-" => ->(a, b) { a - b },
  "*" => ->(a, b) { a * b },
  "/" => ->(a, b) { b == 0 ? "Error: Division by zero" : a / b },
  "%" => ->(a, b) { a % b },
  "^" => ->(a, b) { a**b },
  "sqrt" => ->(a) { a < 0 ? "Error: Cannot take square root of a negative number" : Math.sqrt(a) }
}

def get_number_input
  loop do
    print "Enter a number: "
    input = gets.chomp
    return input.to_f if valid_number?(input)

    puts "Invalid input. Please enter a valid number."
  end
end

def valid_number?(input)
  input.match?(/^[-]?[0-9]*\.?[0-9]+$/)
end

def get_operator_input
  loop do
    print "Enter an operator (+, -, *, /, %, ^, sqrt) or type 'exit' to quit: "
    operator = gets.chomp.downcase
    return operator if OPERATIONS.keys.include?(operator) || operator == "exit"

    puts "Invalid operator. Please enter one of (+, -, *, /, %, ^, sqrt) or 'exit'."
  end
end

def calculate(num1, operator, num2 = nil)
  if operator == "sqrt"
    OPERATIONS[operator].call(num1)
  else
    OPERATIONS[operator].call(num1, num2)
  end
end

def start_calculator
  puts "Welcome to the Hash-Based Ruby Calculator!"
  loop do
    num1 = get_number_input
    operator = get_operator_input
    break if operator == "exit"

    if operator == "sqrt"
      result = calculate(num1, operator)
    else
      num2 = get_number_input
      result = calculate(num1, operator, num2)
    end

    puts "Result: #{result}"
  end
  puts "Goodbye!"
end

start_calculator