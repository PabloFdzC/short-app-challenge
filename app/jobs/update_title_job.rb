require 'open-uri'

class UpdateTitleJob < ApplicationJob
  queue_as :default

  # perform receives a SortUrl object
  # and with the help of open-uri and
  # Nokogiri extracts the title from 
  # the website
  def perform(short_url)    
    # First we use open to get the html
    # file from the url
    URI.open(short_url[:full_url]) do |file|
      # with the document opened we extract the title
      doc = Nokogiri::HTML(file)
      pageTitle =  doc.at_css('title').text
      # then just save it in the database
      short_url.title = pageTitle
      short_url.save
    end
  end
end
