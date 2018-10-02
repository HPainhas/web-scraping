require "mechanize"
require "json"
require "date"
require "nokogiri"
require_relative "article"

# calculates the percentage of articles that have "Ohio State" or "President Michael V. Drake" in their title
def articles_percentage (articles)
  
  # declare variables to keep track of str1 and str2 appearances, and total number of articles
  OSU_count = 0
  President_count = 0
  Article_total = 0
  str1 = "Ohio State"
  str2 = "President Michael V. Drake"
  
  articles.each do |article|
        # if article includes "Ohio State" in its title, add one to OSU_count
        if article.title.to_s.include? str1
              OSU_count += 1
        # if article includes "President Michael V. Drake" in its title, add one to President_count
        elsif article.title.to_s.include? str2
              President_count += 1
        end
        # add one to total number of articles in news.osu.edu
        Article_total += 1
  end
  
  OSU_percentage = (OSU_count.to_f / Article_total.to_f) * 100.to_f
  President_percentage = (President_count.to_f / Article_total.to_f) * 100.to_f
  
  puts "\n#{OSU_percentage}% of articles have \"Ohio State\" in their title"
  puts "\n#{President_percentage}% of articles have \"President Michael V. Drake\" in their title"
end
  
  
  
  
  
  
