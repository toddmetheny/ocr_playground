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
  original_name = file['filename']
  
  if original_name.match(/\s/)
    original_name = original_name.tr(" ", "_")
  end
  
  filename = "ocr_test/#{original_name}"

  puts "filename: #{filename}"
  
  to_s3 = SendToS3.new(file)
  response_hsh = to_s3.upload

  # get text from image
  ocr_image = ImageToText.new(response_hsh[:url], true)
  text_from_image = ocr_image.fetch_text
  
  response_hsh[:text_from_image] = text_from_image
  
  # search the text you got from the image
  unless text_from_image.empty?
    search = Search.new(text_from_image)
    results = search.fetch_results
  else
    results = []
  end
  
  response_hsh[:results] = results

  content_type :json
  response_hsh.to_json
end

