class Search
  
  def initialize(text)
    Algolia.init(application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY'])
    @index = Algolia::Index.new('global_search_dev')
    @text = text
  end

  def fetch_results
    return @index.search(@text)
  end

end