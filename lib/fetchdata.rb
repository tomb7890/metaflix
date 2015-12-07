class Fetchdata

  require "mechanize"
  require 'httparty'
  require 'open-uri'

  def escape_query(query)
    require 'webrick'
    query.force_encoding('binary')
    query=WEBrick::HTTPUtils.escape(query)
  end

  def get_movies

    (1...6).each do |page|

      url = "http://can.whatsnewonnetflix.com/?page=#{page}"

      agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
      html = agent.get(url).body
      html_doc = Nokogiri::HTML(html)

      movieentries = html_doc.xpath("//div[contains(concat(' ', @class, ' '), 'mr_')]")
      movieentries.each do |movieentry|
        title = movieentry.xpath("div[@class='cover']//a/@title").text()
        description = movieentry.xpath("div[@class='content']//p").first.text()
        year = movieentry.xpath('.//span[@class="year"]').text

        launchurl =   movieentry.xpath("div[@class='content']//a/@href").text()
        imgurl =      movieentry.xpath("div[@class='cover']//img/@src").text()

        query = "http://www.omdbapi.com/?t=#{title}&y=#{year}&plot=full&r=json"
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
