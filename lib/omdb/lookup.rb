module OMDB
  class Lookup

    attr_accessor :title
    
    include HTTParty
    base_uri 'http://www.omdbapi.com'

    def initialize(title, year = nil)
      self.title = title
      api_key = ENV['OMDB_API_KEY']
      @options = { query: { t: title, apikey: api_key, plot: "full" } }
      @options[:query][:y] = year unless year.nil?
    end
    
    def profile(force = false)
      force ? @profile = get_profile : @profile ||= get_profile
    end

    def method_missing(name, *args, &block)
      profile.key?(name.to_s) ? profile[name.to_s] : super
    end

    private

    def get_profile
      response = self.class.get '/', @options 
      response.parsed_response
    end
  end
end
