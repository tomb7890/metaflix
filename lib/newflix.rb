class Newflix
  require "mechanize"

  BASE_URL = 'https://whatsnewonnetflix.com'

  def page(page_number)
    mechanize = Mechanize.new
    path = "/canada/netflix-canada-new-releases/#{page_number}"
    html_doc = dom_tree(path, mechanize)
    movieentries = html_doc.xpath("//div[@class='card card--md layout-2 movie']")
    movieentries.map{ |m| discover_attributes(m, mechanize) }
  end

  private

  def dom_tree(path, mechanize)
    url = BASE_URL + path
    html = mechanize.get(url).body
    Nokogiri::HTML(html)
  end

  def discover_attributes(movieentry, mechanize)
    attrs = {}
    attrs['title'] = movieentry.xpath(".//span[@class='entry_name']").text()
    attrs['description'] = movieentry.xpath(".//p[@class='truncate']").text()
    attrs['launchurl'] = movieentry.xpath(".//a[@class='no_cookies_param card__button link-prefix-icon play_on_netflix']/@href").text
    attrs['imgurl']      = movieentry.xpath(".//div[@class='card__cover']//img/@src").text

    if attrs['imgurl'].empty? || attrs['imgurl'] =~ /^data\:image.*/ 
      attrs['imgurl']      = movieentry.xpath(".//div[@class='card__cover']//img/@data-src").text
    end
    
    attrs
  end
end
