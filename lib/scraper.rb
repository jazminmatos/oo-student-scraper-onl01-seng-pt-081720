require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_cards = doc.css(".student-card a")
    
    student_cards.collect do |a|
      {:name => a.css(".student-name").text, :location => a.css(".student-location").text, :profile_url => a.attr('href')}
    end
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    return_hash = {}

    social = doc.css(".vitals-container .social-icon-container a")
      social.each do |a| 
        if a.attr('href').include?("twitter")
          return_hash[:twitter] = a.attr('href')
        elsif a.attr('href').include?("linkedin")
          return_hash[:linkedin] = a.attr('href')
        elsif a.attr('href').include?("github")
          return_hash[:github] = a.attr('href')
        elsif a.attr('href').end_with?("com/")
          return_hash[:blog] = a.attr('href')
        end
      end
      return_hash[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
      return_hash[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

      return_hash
    end
end

