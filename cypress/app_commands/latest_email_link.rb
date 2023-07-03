# frozen_string_literal: true

html = ActionMailer::Base.deliveries.last.body.raw_source
nokogiri_element = Nokogiri::HTML(html)
nokogiri_element.search('a')[0].values[0]
