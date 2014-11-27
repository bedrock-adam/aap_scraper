class ResultsPage
  def self.first_page
    @first_page ||= ResultsPage.new first_page_uri
  end

  def self.first_page_uri
    URI.parse('http://adoptapet.com.au/search/searchResults.asp?task=search&searchid=&advanced=&s=&animalType=&searchType=4&state=&regionID=&submitbtn=Find+Animals')
  end

  def ok?
    @is_ok ||= resp.code == '200'
  end

  def next_page
    @next_page ||= more_pages? ? ResultsPage.new(next_page_uri) : nil
  end

  def more_pages?
    @has_more_pages || doc.xpath("count(id('searchPageTableTop')//a[contains(text(), '>>')])").to_i > 0
  end

  def next_page_uri
    @next_page_uri ||= URI.parse doc.xpath("id('searchPageTableTop')//a[contains(text(), '>>')]")
  end

  def links
    @links ||= doc.xpath("//a[@class='view_details']/@href").
      map(&:text).
      map { |path| URI.join 'http://adoptapet.com.au/', path }
  end

  def page_num
    @page_num ||= doc.xpath("id('searchPageTableTop')//b[@class='SearchResultsPageLink']/text()")
  end

  private

  attr_accessor :uri

  def initialize(uri)
    self.uri = uri
    raise "HTTP Error #{resp.code}]: #{uri}" unless ok?
  end

  def resp
    @resp ||= Net::HTTP.get_response uri
  end

  def doc
    @doc ||= Nokogiri::HTML resp.body
  end
end
