require 'cloudmersive-ocr-api-client'
require 'open-uri'
# move this to its own file
class ImageToText

    def initialize(file, is_url=false)
      CloudmersiveOcrApiClient.configure do |config|
        config.api_key['Apikey'] = ENV['CLOUDMERSIVE_API_KEY']
      end
  
      @api_instance = CloudmersiveOcrApiClient::ImageOcrApi.new
  
      @file = file
      @is_url = is_url
    end
  
    def image_file
      if @is_url
        image_file = open('image.png', 'wb') do |file|
          file << open(@file).read
        end
      else # it's a path instead
        @image_file = File.new(@file) # File | Image file to perform OCR on.  Common file formats such as PNG, JPEG are supported.
      end
    end
  
    def fetch_text
      opts = { 
        language: "ENG",
        preprocessing: "Auto"
      }
    
      begin
        result = @api_instance.image_ocr_post(self.image_file, opts)
        
        text_result = result.text_result.gsub("\n", "")
        return text_result
      rescue CloudmersiveOcrApiClient::ApiError => e
        puts "Exception when calling ImageOcrApi->image_ocr_post: #{e}"
      end
    end
  
  end