class Newflix
  require "mechanize"

  BASE_URL = "https://newonnetflix.com"
  
  def page(page_number)
    mechanize = Mechanize.new 
    html_doc = dom_tree(page_number, mechanize )
    movieentries = html_doc.xpath("//div[contains(concat(' ', @class, ' '), 'mr_')]")
    movieentries.map{ |m| discover_attributes(m) }
  end

  private

  def dom_tree(page_number, mechanize)
    url = BASE_URL + "/canada?page=#{page_number}"
    html = mechanize.get(url).body
    Nokogiri::HTML(html)
  end

  def discover_attributes(movieentry)
    attrs = {}
    attrs['title']       = movieentry.xpath("div[@class='cover']//a/@title").text()
    attrs['description'] = movieentry.xpath("div[@class='content']//p").first.text()
    attrs['year']        = movieentry.xpath('.//span[@class="year"]').text
    attrs['launchurl']   = movieentry.xpath("div[@class='content']//a/@href").text()
    attrs['imgurl']      = movieentry.xpath("div[@class='cover']//img/@src").text()
    attrs
  end
end

