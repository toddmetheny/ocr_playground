require 'aws-sdk-s3'

class SendToS3
  def initialize(file)
    @file = file

    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
    })
    
    @s3 = Aws::S3::Resource.new(region: 'us-east-1')
  end

  def upload
    filename = "ocr_test/#{@file['filename']}"
    bucket = 'lightcat-files'
    
    obj = @s3.bucket(bucket).object(filename)

    tmp = @file['tempfile']
    puts tmp.inspect
    response = obj.upload_file(tmp, {acl: "public-read"})
    
    if response
      resp = obj.acl.put({acl: "public-read"})

      url = "https://s3.amazonaws.com/lightcat-files/#{filename}"
    else 
      filename = "Google"
      url = "https://google.com"
    end

    return {filename: filename, url: url}
  end
end