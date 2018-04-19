class Fetchdata

  require "mechanize"
  require 'httparty'
  require 'open-uri'
  require 'webrick'

  def api_key
    ENV['OMDB_API_KEY']
  end

  def prepare_query(attrs)
    query_text = "http://www.omdbapi.com/?t=#{attrs['title']}&y=#{attrs['year']}&plot=full&r=json&apikey=#{api_key}" 
    query_text.force_encoding('binary')
    WEBrick::HTTPUtils.escape(query_text)
  end

  def dom_tree_from_page_no(page, agent)
    url = "https://newonnetflix.com/canada?page=#{page}"
    html = agent.get(url).body
    Nokogiri::HTML(html)
  end

  def discover_attributes(movieentry)
    attrs = {}
    attrs['title'] = movieentry.xpath("div[@class='cover']//a/@title").text()
    attrs['description'] = movieentry.xpath("div[@class='content']//p").first.text()
    attrs['year'] = movieentry.xpath('.//span[@class="year"]').text
    attrs['launchurl'] =   movieentry.xpath("div[@class='content']//a/@href").text()
    attrs['imgurl'] =  movieentry.xpath("div[@class='cover']//img/@src").text()
    attrs
  end

  def create_db_entry(attrs)
    Movie.create(title:
                   attrs['title'], year: attrs['year'],
                 description: attrs['description'],
                 launchurl: attrs['launchurl'],
                 imgurl: attrs['imgurl'],
                 imdbscore: attrs['rx'],
                 metascore: attrs['rm']) unless Movie.find_by(description: attrs['description'])
  end

  def get_movies
    agent = Mechanize.new { |a| a.user_agent_alias = "Mac Safari" }
    (1...6).each do |page|
      html_doc = dom_tree_from_page_no(page, agent)
      movieentries = html_doc.xpath("//div[contains(concat(' ', @class, ' '), 'mr_')]")
      movieentries.each do |movieentry|
        attrs = discover_attributes(movieentry)

        query = prepare_query(attrs)
        
        begin
          response = HTTParty.get(query)
          attrs['rm'] = response['Metascore']
          attrs['rx'] = response['imdbRating']
          create_db_entry(attrs)
        rescue => e
          puts "Exception: #{e} "
        end
      end
    end
  end
end
