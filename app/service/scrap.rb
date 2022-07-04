class Scrap
  # def initialize
  #   super
  # end
  @@url = "https://www.visitberlin.de/en/event-calendar-berlin"
  @@base_url = "https://www.visitberlin.de"
  def self.start
    puts "HELLLO"
    page = 1
     # put here category link
    url = "#{@@url}?page=#{page}"
    unparsed_page = ::HTTParty.get(url)
    parsed_page = ::Nokogiri::HTML(unparsed_page)
    last_page = parsed_page.css("li.pager__item.pager__item--last > a").first.attributes["href"].value.gsub("?page=","").to_i

    events_calendar = parsed_page.css("li.l-list__item")

    p events_calendar.count
    p image_url = @@base_url + events_calendar.first.css("img.teaser-search__img.fluid-img").first.attributes["src"].value
    p "#" * 3
    p title = events_calendar.first.css("span.heading-highlight__inner").last.text.strip
    p dates = events_calendar.first.css("span.heading-highlight__inner").first.text.strip.gsub("–","").split()
    p start_date = dates.first.to_time
    p end_date = dates.last.to_time
    p description = events_calendar.first.css(".teaser-search__text").first.text.strip
    p location = events_calendar.first.css("span.nopr").text.strip
    p category = events_calendar.first.css("a.category-label").text.strip
    p url = @@base_url + events_calendar.first.css("article").first["about"]


    # items = []
    # while page <= last_page
    #   url = "#{@@url}?page=#{page}"
    #   unparsed_page = ::HTTParty.get(url)
    #   parsed_page = ::Nokogiri::HTML(unparsed_page)
    #
    # end

    end
end
Scrap.start
