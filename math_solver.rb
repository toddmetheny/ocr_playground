class MathSolver
  def initialize(text_result)
    @text_result = text_result.split('')
    p "@text_result: #{@text_result}"
  end

  def solve
    if (@text_result & self.operators).empty?
      p "not a math problem"
      return
    end
    
    p component_arr = @text_result

    operator =[]
    integers = []

    p "component_arr: #{component_arr}"

    component_arr.each do |i|
      p "self.operators: #{self.operators}"
      p "i: #{i}"

      if self.operators.include?(i)
        operator << i
      elsif Integer(i)
        integers << i.to_i
      end
    end

    total = self.calculate(operator, integers)

    puts "#{@text_result.join('')} equals #{total}"
    return total
  end

  def operators
    ["+", "-", "*", "/"]
  end

  # only contemplating 2 numbers
  def calculate(operator, integers)
    total = 0
    if operator.first == "+"
      integers.each {|i| total += i}
    elsif operator.first == "-"
      total = integers.first - integers.last
    elsif operator.first == "*"
      total = integers.first * integers.last
    elsif operator.first == "/"
      total = integers.first / integers.last
    end 
    return total
  end
end