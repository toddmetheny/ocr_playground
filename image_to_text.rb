require "cloudmersive-ocr-api-client"
require "open-uri"

class ImageToText
  def initialize(file, is_url = false)
    CloudmersiveOcrApiClient.configure do |config|
      config.api_key["Apikey"] = ENV["CLOUDMERSIVE_API_KEY"]
    end

    @api_instance = CloudmersiveOcrApiClient::ImageOcrApi.new
    @opts = {language: "ENG", preprocessing: "Auto"}

    @file = file
    @is_url = is_url
  end

  def image_file
    if @is_url
      image_file = open("image.png", "wb") do |file|
        file << open(@file).read
      end
    else # it's a path instead
      @image_file = File.new(@file)
    end
  end

  def fetch_text
    begin
      result = @api_instance.image_ocr_post(self.image_file, @opts)

      if result.text_result.empty?
        return ""
      else
        text_result = result.text_result.gsub("\n", "")
        return text_result
      end
    rescue CloudmersiveOcrApiClient::ApiError => e
      puts "Exception when calling ImageOcrApi->image_ocr_post: #{e}"
    end
  end
end
