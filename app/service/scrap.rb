class Scrap
    @@base_url = 'https://www.visitberlin.de'
    @@url = 'https://www.visitberlin.de/en/event-calendar-berlin'
    @@data_source = 'visitberlin'


    def self.start
      page = 1
      url = "#{@@url}?page=#{page}"
      unparsed_page = ::HTTParty.get(url)
      parsed_page = ::Nokogiri::HTML(unparsed_page)
      last_page = parsed_page.css('li.pager__item.pager__item--last > a').first.attributes['href'].value.gsub('?page=',
                                                                                                              '').to_i

      items = []
      # Looping with pagination
      while page <= last_page
        items = loop_pagination(page, items)
        p "Done #{page}"
        page += 1
      end

      # to take alwys backup logs dates if site breaken data
      ["#{Time.now.to_i}_export_data", 'export_data'].each { |file_name| parse_json(items, file_name) }
    end

    def self.loop_pagination(page, items)
      url = "#{@@url}?page=#{page}"
      unparsed_page = ::HTTParty.get(url)
      parsed_page = ::Nokogiri::HTML(unparsed_page)
      events_calendar = parsed_page.css('li.l-list__item')
      events_calendar.each do |event|
        # get here dates and compare between start date and end date
        dates = event.css('span.heading-highlight__inner').first.text.strip.gsub('–', '').split
        begin
          item = {
            title: event.css('span.heading-highlight__inner').last.text.strip,
            start_date: dates.first.to_time,
            end_date: dates.last.to_time,
            description: event.css('.teaser-search__text').first.text.strip,
            location: event.css('span.nopr').text.strip,
            category: event.css('a.category-label').text.strip,
            image_url: @@base_url + event.css('img.teaser-search__img.fluid-img')&.first&.attributes['src']&.value,
            url: @@base_url + event.css('article').first['about'],
            data_source: @@data_source
          }
          items.append(item)
        rescue StandardError => e
          puts e
        end
      end
      items
    end

    def self.parse_json(items, file_name)
      # write with two files
      schema = { data: items }.to_json
      file = File.join(Rails.root, 'db', 'seeds_json', "#{file_name}.json")
      File.write(file, schema)
    end
end