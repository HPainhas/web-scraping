require "mechanize"
require "json"
require "date"
require_relative "article"

class WebScraper

	# Send GET request to news.osu.edu to get an array of all of the public article IDs
	def self.get_articles_ids
		# send get request
	    page = @agent.get("https://news.osu.edu", {
	        "h" => "1",
	        "t" => "News"
	    })

	    # find article ids
	    article_ids = page.body.slice(page.body.index("var jsArray = [") + 14..-1)
	    article_ids = article_ids.slice(0..article_ids.index("];"))
    end

	# Send GET request to news.osu.edu to grab headline information for all of the articles
	def self.get_articles
	    @agent = Mechanize.new
	    articles = Array.new

	    # send get request
	    page = @agent.get("https://news.osu.edu/services/getheadlines.php", {
	        "archive" => "1",
	        "releases" => get_articles_ids,
	        "type" => "1",
	        "umbrella" => "0"
	    })

	    # get article meta data and populate articles array
	    json_response = JSON.parse page.body
	    json_response.each do |article|
	        article = Article.new(article[1]["title"], article[1]["subtitle"], Date.parse(article[1]["date"]), article[1]["tags"])
	        articles << article
	    end

	    return articles
	end

end # end class
