require 'sinatra'
require 'json'

require './image_to_text.rb'
require './send_to_s3.rb'
require './search.rb'

# sinatra routes
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

  if results.any?
    response_hsh[:results] = results
  end

  content_type :json
  response_hsh.to_json
end

