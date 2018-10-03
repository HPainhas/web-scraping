require_relative "web_scraping"
require_relative "data_hdl"

### Main file, handles user input and runs tasks ###

# Prompt user for what they data they would like
def user_prompt
    puts "Choose one of the following options:"
    puts "0. Quit."
    puts "1. Change the year range being analyzed."
    puts "2. Count number of occurrences for tags."
    puts "3. Search article titles for any string."
    puts "4. Graph the number of articles posted by year."
    puts "5. Graph average tags per article by year."
    puts "6. Find longest article title."
    puts "7. Calculate average title length per month."
    gets.chomp.to_i
end

# Prompt user for year range to analyze and update instance variable articles_in_range
def user_prompt_year_range(articles, min_year, max_year)
    puts "\nPublication dates range from #{min_year} to #{max_year}."
    puts "Please select the years you would like to analyze."

    # prompt user for starting year and loop for valid input
    puts "Enter a starting year:"
    while beginning_year = gets.chomp.to_i
        unless max_year >= beginning_year && beginning_year >= min_year
            puts "Invalid input! Please reenter:"
        else
            break
        end
    end

    # prompt user for ending year and loop for valid input
    puts "Enter an ending year:"
    while ending_year = gets.chomp.to_i
        unless beginning_year <= ending_year && ending_year <= max_year
            puts "Invalid input! Please reenter:"
        else
            break
        end
    end

    # get articles in user specified range
    @articles_in_range = articles.select { |article| article.date.year.between? beginning_year, ending_year }

    # check if any articles were found
    if @articles_in_range.length == 0
        puts "Warning: No articles were published in the year range you provided. Please select a different range."
    end

    return beginning_year, ending_year
end

puts "Scraping https://news.osu.edu for articles..."
articles = WebScraper.get_articles # get article meta data

# find earliest and latest publication years
min_year = articles.min_by(&:date).date.year
max_year = articles.max_by(&:date).date.year

# ask user for what years they want to look at
beginning_year, ending_year = user_prompt_year_range(articles, min_year, max_year)

# loop for user input and do stuff with article data
while((choice = user_prompt) != 0)
    puts # \n
    case choice
    when 1        
        beginning_year, ending_year = user_prompt_year_range(articles, min_year, max_year) # change year range
    when 2
        DataHdl.find_tags @articles_in_range # find tags
    when 3
        DataHdl.find_title_str @articles_in_range # search article titles for str
    when 4
        DataHdl.graph_articles_by_year @articles_in_range # graph articles by year
    when 5
        DataHdl.graph_avg_tags_by_year @articles_in_range # graph tags by year
    when 6
        DataHdl.longest_title @articles_in_range # find longest title
    when 7
        DataHdl.avg_title_len @articles_in_range # find avg title length
    end

    # notify user of what year range is being looked at
    puts "\nCurrently analyzing articles from years #{beginning_year} - #{ending_year}"
end
