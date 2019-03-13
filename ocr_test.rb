# https://web.stanford.edu/class/cs231a/prev_projects_2016/optical_recognition_of_chemical_structures.pdf

require 'algoliasearch'
require 'sinatra'
require 'json'

require './image_to_text.rb'
require './send_to_s3.rb'
require './search.rb'

get '/' do
  send_file 'public/ocr_test.html'
end

post '/get_image_url' do
  file = params['file']
  filename = "ocr_test/#{file['filename']}"
  
  to_s3 = SendToS3.new(file)
  response_hsh = to_s3.upload
  p "response_hsh.inspect before text_from_image: #{response_hsh.inspect}"

  ocr_image = ImageToText.new(response_hsh[:url], true)
  text_from_image = ocr_image.fetch_text
  
  response_hsh[:text_from_image] = text_from_image
  
  p "response_hash: #{response_hsh}"
  search = Search.new(text_from_image)
  results = search.fetch_results

  if results['hits'].any?
    response_hsh[:results] = results['hits']
  end

  content_type :json
  response_hsh.to_json
end


# class MathSolver
#   def initialize(text_result)
#     @text_result = text_result.split('')
#     p "@text_result: #{@text_result}"
#   end

#   def solve
#     if (@text_result & self.operators).empty?
#       p "not a math problem"
#       return
#     end
    
#     p component_arr = @text_result

#     operator =[]
#     integers = []

#     p "component_arr: #{component_arr}"

#     component_arr.each do |i|
#       p "self.operators: #{self.operators}"
#       p "i: #{i}"

#       if self.operators.include?(i)
#         operator << i
#       elsif Integer(i)
#         integers << i.to_i
#       end
#     end

#     total = self.calculate(operator, integers)

#     puts "#{@text_result.join('')} equals #{total}"
#     return total
#   end

#   def operators
#     ["+", "-", "*", "/"]
#   end

#   # only contemplating 2 numbers
#   def calculate(operator, integers)
#     total = 0
#     if operator.first == "+"
#       integers.each {|i| total += i}
#     elsif operator.first == "-"
#       total = integers.first - integers.last
#     elsif operator.first == "*"
#       total = integers.first * integers.last
#     elsif operator.first == "/"
#       total = integers.first / integers.last
#     end 
#     return total
#   end
# end

# image = ImageToText.new("https://s3.amazonaws.com/lightcat-files/ocr_test/ocr_test2.png", true)
# # math_image = ImageToText.new("https://s3.amazonaws.com/lightcat-files/ocr_test/two_plus_two.png", true)

# search_results = Search.new(image.fetch_text)

# problem = MathSolver.new(math_image.fetch_text)
# problem.solve

