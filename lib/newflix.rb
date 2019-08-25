class Newflix
  require "mechanize"

  BASE_URL = 'https://whatsnewonnetflix.com'

  def page(page_number)
    mechanize = Mechanize.new
    path = "/canada/netflix-canada-new-releases/#{page_number}"
    html_doc = dom_tree(path, mechanize)
    movieentries = html_doc.xpath("//a[@class='no_cookies_params link-arrow']/@href")
    movieentries.map{ |m| discover_attributes(m, mechanize) }
  end

  private

  def dom_tree(path, mechanize)
    url = BASE_URL + path
    html = mechanize.get(url).body
    Nokogiri::HTML(html)
  end

  def discover_attributes(link, mechanize)
    sleep(2.0)
    movieentry = dom_tree(link, mechanize)
    attrs = {}
    attrs['title'] = movieentry.xpath("//div[@class='single__header']//strong").text()
    attrs['description'] = movieentry.xpath("//div[@class='single__section']//p")[0].text()
    attrs['year'] = movieentry.xpath("//div[@class='single__header']//small").text().gsub(/[()]/, '')
    attrs['launchurl']   = movieentry.xpath("//article/div/a/@href").text()
    attrs['imgurl']      = movieentry.xpath("//img[@class='single__cover']/@src")
    attrs
  end
end
