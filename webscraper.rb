require "mechanize"
require "json"
require "date"
requite "nokogiri"
require_relative "article"

# calculates the percentage of articles that have "Ohio State" in their title and "President Michael V. Drake" in the body
def articles_percentage (articles)
  
  # declare variables to keep track of str1 and str2 appearances
  OSU_count = 0
  President_count = 0
  str1 = "Ohio State"
  str2 = "President Michael V. Drake"
  
  articles.each do |article|
        if article.title.to_s.include? str1
              OSU_count += 1
        end
  end
  
  
  
  
  
  
  
