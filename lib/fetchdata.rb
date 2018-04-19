class Fetchdata

  require "mechanize"
  require 'httparty'
  require 'open-uri'

  def api_key
    ENV['OMDB_API_KEY']
  end

  def escape_query(query)
    require 'webrick'
    query.force_encoding('binary')
    query=WEBrick::HTTPUtils.escape(query)
  end

  def get_movies

    agent = Mechanize.new { |a| a.user_agent_alias = "Mac Safari" }

    (1...6).each do |page|

      url = "https://newonnetflix.com/canada?page=#{page}"


      html = agent.get(url).body
      html_doc = Nokogiri::HTML(html)

      movieentries = html_doc.xpath("//div[contains(concat(' ', @class, ' '), 'mr_')]")
      movieentries.each do |movieentry|
        title = movieentry.xpath("div[@class='cover']//a/@title").text()
        description = movieentry.xpath("div[@class='content']//p").first.text()
        year = movieentry.xpath('.//span[@class="year"]').text

        launchurl =   movieentry.xpath("div[@class='content']//a/@href").text()
        imgurl =      movieentry.xpath("div[@class='cover']//img/@src").text()

        query = "http://www.omdbapi.com/?t=#{title}&y=#{year}&plot=full&r=json&apikey=#{api_key}"
        query = escape_query( query )

        begin
          response = HTTParty.get(query)

          rm = response['Metascore']
          rx = response['imdbRating']

          unless Movie.find_by(description: description)
            Movie.create(title: title, year: year,
                         description: description,
                         launchurl: launchurl,
                         imgurl: imgurl,
                         imdbscore: rx,
                         metascore: rm )
          end

        rescue => e
          puts "Exception: #{e} "
        end

      end
    end
  end
end
