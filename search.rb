class Search
  
  def initialize(text)
    Algolia.init(application_id: ENV['ALGOLIA_APPLICATION_ID'], api_key: ENV['ALGOLIA_API_KEY'])
    @index = Algolia::Index.new('global_search')
    @text = text
  end

  def fetch_results
    results = @index.search(@text)
    results_arr = []
    if results['hits'].empty?
      return "empty"
    else
      base_url = "https://www.clutchprep.com"
      results['hits'].each do |hit|
        if hit['result_type'] == "question"
          url = "#{base_url}/questions/#{hit['question_id']}/#{hit['slug']}"
          title = "Q&A:"
        elsif hit['result_type'] == "problem"
          url = "#{base_url}/#{hit['subject_slug']}/practice-problems/#{hit['problem_id']}/#{hit['slug']}"
          title = "Practice Problem:"
        end
        results_arr << {description: hit['description'], url: url, title: title}
      end
    end
    
    return results_arr
  end

end