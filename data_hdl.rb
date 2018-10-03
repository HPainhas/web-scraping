require "gruff"
require_relative "article"

# class to process article meta data
class DataHdl

    # counts tag appearances
    def self.find_tags(articles)
        tags = Hash.new 0 # define new hash

        # add tags to hash
        articles.each do |article|
            article.tags.each { |tag| tags[tag] += 1 }
        end

        keys = tags.keys.sort { |a, b| a.downcase <=> b.downcase } # sort alphabetically
        puts "\nPrinting tags and their frequency...\n"
        keys.each { |key| puts "#{key} : #{tags[key]}"} # print tags and how many times they appear
        puts "Found #{keys.size} different tags."
    end

    # searches titles for a given str
    def self.find_title_str(articles)
        # get user str
        puts "Enter a case sensitive string to search for: "
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

    # finds the average title length of articles per month
    def self.avg_title_len(articles)
        monthly_titles = Hash.new {|h, k| h[k] = Array.new}

        articles.each {|article| monthly_titles[article.date.month] << article.title.length}

        monthly_titles.sort.each do |month, title_lengths|
            avg_length = title_lengths.reduce(:+).to_f / title_lengths.length
            puts "#{Date::MONTHNAMES[month]}: #{avg_length} characters"
        end
    end

    # finds longest article title
    def self.longest_title(articles)
        # iterates through array of titles and find longest title
        longest = articles.reduce do |a1,a2|
            a1.title.size > a2.title.size ? a1 : a2
        end

        # print longest title
        if(longest.nil?)
            puts "There is no longest article title since there are no articles in your selected date range."
        else
            puts "\nLongest article title is \"#{longest.title}\""
        end
    end

    # Finds the average number of tags per article for each year in range and graphs
    def self.graph_avg_tags_by_year(articles)

        #Create new bar graph
        g = Gruff::Bar.new
        g.title = "Avg. Number of Tags Per Article"
        g.sort = false
        g.y_axis_increment = 1
        g.y_axis_label = "Number of Tags"
        g.show_labels_for_bar_values = true

        # Define new hashes
        article_num = Hash.new 0
        total_tag_num = Hash.new 0

        # For each article, find the year it was posted and number of tags and add to respective hash
        articles.each do |article|
            article_num[article.date.year] += 1
            total_tag_num[article.date.year] += article.tags.length
        end

        # For each year, calculate the average number of tags per article and add to plot
        total_tag_num.each do |year|
            # average = (total tags that year) / (num articles that year)
            avg = year[1].to_f / article_num[year[0]].to_f
            g.data year[0], avg
        end

        # set minimum value for y axis
        g.minimum_value = 0

        #Write graph to file
        graph_file = "avg_tags_per_year.png"
        g.write graph_file
        puts "The graph has been saved to #{graph_file}"

    end	

    # Graphs the number of articles posted in given years on a bar graph
    def self.graph_articles_by_year(articles)

        # Create new bar graph
        g = Gruff::Bar.new
        g.title = "Number of Articles Posted by Year"
        g.sort = false
        g.y_axis_increment = 10		
        g.y_axis_label = "Number of Articles"
        g.show_labels_for_bar_values = true

        # Define new hash
        years = Hash.new 0

        # For each article, find the year it was posted and add years to hash
        articles.each do |article|
            years[article.date.year] += 1
        end

        # for each pair in hash, plot the year and number of articles in that year
        years.each do |year|
            g.data year[0].to_s, year[1]
        end

        # set minimum value for y axis
        g.minimum_value = 0

        # Write graph to file
        graph_file = "article_number_by_year.png"
        g.write graph_file
        puts "The graph has been saved to #{graph_file}"
    end

end # end class
