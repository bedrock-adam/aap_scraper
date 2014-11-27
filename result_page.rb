class ResultPage
  def initialize(uri)
    self.uri = uri
    raise "HTTP Error #{resp.code}]: #{uri}" unless ok?
  end

  def name
    @name ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Name']/td[2]/text())"
  end

  def type
    @type ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Type']/td[2]/text())"
  end

  def breed
    @breed ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Breed']/td[2]/text())"
  end

  def lifestyle_colour
    @lifestyle_colour ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Lifestyle Colour']/td[2]//span/text()))"
  end

  def sex
    @sex ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Sex']/td[2]/text())"
  end

  def size
    @size ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Size']/td[2]/text())"
  end

  def colour
    @colour ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Colour']/td[2])"
  end

  def age
    @age ||= doc.xpath "normalize-space(//table[@class='animal_details_table']//tr[td/text()='Age']/td[2])"
  end

  def animal_id
    @animal_id ||= doc.xpath("normalize-space(//table[@class='animal_details_table']//tr[td/text()='Animal ID']/td[2])").to_i
  end

  def location
    @location ||= doc.xpath "//table[@class='animal_details_table']//tr[td/text()='Location']/td[2]"
  end

  def phone
    @phone ||= doc.xpath "//table[@class='animal_details_table']//tr[td/text()='Phone']/td[2]"
  end

  def address
    @address ||= doc.xpath "//table[@class='animal_details_table']//tr[td/text()='Address']/td[2]" # /\<br ?\/?\>/
  end

  def image_url
    @image_url ||= doc.xpath("id('petDefaultPic')/@src")
  end

  def description
    @description ||= doc.xpath("id('litte_bit_about_me')/p[@class='page_content']/text()").
      map(&:text).
      map(&:presence).
      compact
  end

  def attrs
    {
      uri: uri.to_s,
      name: name,
      type: type,
      breed: breed,
      lifestyle_colour: lifestyle_colour,
      sex: sex,
      size: size,
      colour: colour,
      age: age,
      animal_id: animal_id,
      location: location,
      phone: phone,
      address: address,
      image_url: image_url,
      description: description
    }
  end

  private

  def doc
    @doc ||= Nokogiri::HTML resp.body
  end

  def resp
    @resp ||= Net::HTTP.get_response uri
  end

  def ok?
    @is_ok ||= resp.code == '200'
  end
end
