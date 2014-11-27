class Scraper
  def initialize
    self.links = Set.new
  end

  def start
    current_page = ResultsPage.first_page

    while current_page do
      links += current_page.links

      current_page = current_page.next_page
    end
  end

  def dump!
    File.open('animals.yaml', 'w') do |out|
      YAML.dump(links, out)
    end
  end

  private

  attr_accessor :links
end
