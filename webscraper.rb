require "mechanize"
require "json"
require "date"
require_relative "article"

# Send GET request to news.osu.edu to get an array of all of the public article IDs
def get_articles_ids
    page = @agent.get("https://news.osu.edu", {
        "h" => "1",
        "t" => "News"
    })

    article_ids = page.body.slice(page.body.index("var jsArray = [") + 14..-1)
    article_ids = article_ids.slice(0..article_ids.index("];"))
end

# Send GET request to news.osu.edu to grab headline information for all of the articles
def get_articles
    @agent = Mechanize.new
    articles = Array.new

    page = @agent.get("https://news.osu.edu/services/getheadlines.php", {
        "archive" => "1",
        "releases" => get_articles_ids,
        "type" => "1",
        "umbrella" => "0"
    })

    json_response = JSON.parse page.body

    json_response.each do |article|
        article = Article.new(article[1]["title"], article[1]["subtitle"], Date.parse(article[1]["date"]), article[1]["tags"])
        articles << article
    end

    return articles
end

# Prompt user for what they data they would like
def user_prompt
    puts "Choose one of the following options:"
    puts "0. Quit"
    puts "1. Change the year range being analyzed"
    puts "2. Count number of occurrences for tags"
    puts "3. Find number of article titles that contain any string"
    gets.chomp.to_i
end

# Prompt user for year range to analyze and update instance variable articles_in_range
def user_prompt_year_range(articles, min_year, max_year)
    puts "Enter a starting year (the first article was published in #{min_year})"
    beginning_year = gets.chomp.to_i #TODO: Handle invalid user input

    puts "Enter an ending year (the last article was published in #{max_year})"
    ending_year = gets.chomp.to_i

    @articles_in_range = articles.select {|article| article.date.year.between?(beginning_year, ending_year)}

    return beginning_year, ending_year
end

# counts tag appearances
def find_tags(articles)
	tags = Hash.new 0 # define new hash

	# add tags to hash
	articles.each do |article|
		article.tags.each { |tag| tags[tag] += 1 }
	end

	# print tags alphabetically
	keys = tags.keys.sort { |a, b| a.downcase <=> b.downcase }
	keys.each { |key| puts "#{key} : #{tags[key]}"}
end

def find_title_str(articles)
	# get user str
	puts "Enter the string you want to search for: "
	str = gets.chomp

	# search titles for str
	total = 0
	articles.each do |article|
		if article.title.to_s.include? str
			total += 1
		end
	end

	puts "\n#{total} article titles contain \"#{str}\"" # print result
end

# calculates the percentage of articles that have "Ohio State" or "President Michael V. Drake" in their title
def articles_percentage(articles)
  
	# declare variables to keep track of str1 and str2 appearances, and total number of articles
  	osu_count = 0
  	president_count = 0
  	article_total = 0
	
  	str1 = "Ohio State"
  	str2 = "President Michael V. Drake"
  
  	articles.each do |article|
  		# if article includes "Ohio State" in its title, add one to osu_count
        	if article.title.to_s.include? str1
        	osu_count += 1
        	# if article includes "President Michael V. Drake" in its title, add one to president_count
        	elsif article.title.to_s.include? str2
        	president_count += 1
        end
		
        # add one to total number of articles in news.osu.edu
        article_total += 1
	end
  	
	# calculates percentages
  	osu_percentage = (osu_count.to_f / Article_total.to_f) * 100.to_f
  	president_percentage = (president_count.to_f / article_total.to_f) * 100.to_f
  
	# prints percentages
  	puts "\n#{osu_percentage}% of articles have \"Ohio State\" in their title"
  	puts "\n#{president_percentage}% of articles have \"President Michael V. Drake\" in their title"
end

# find average title length of all articles posted in news.osu.edu
def average_title_length(articles)
	
	word_count = 0
	total_count = 0
	
	# get the word count of each title and stores it in word_count, also count number of titles
	article.title.each do |title|
		word_count += title.scan(/[\w-]+/).size
		total_count += 1
	end
	
	#calculates average word length
	average_word_length = (word_count/ total_count)
		
	puts "\nAverage title length: #{average_word_length} words"
end

# find longest title in news.osu.edu
def longes_title(articles)
	longest = articles.title.inject do |title1,title2|
		title1.length > title2.length? title1 : title2
	end
end

articles = get_articles

min_year = articles.min_by(&:date).date.year
max_year = articles.max_by(&:date).date.year

beginning_year, ending_year = user_prompt_year_range(articles, min_year, max_year)

while((choice = user_prompt) != 0)
    case choice
    when 1        
        beginning_year, ending_year = user_prompt_year_range(articles, min_year, max_year)
    when 2
    	find_tags @articles_in_range
	when 3
		find_title_str @articles_in_range
    end

    puts "\nCurrently analyzing articles from years #{beginning_year} - #{ending_year}"
end
