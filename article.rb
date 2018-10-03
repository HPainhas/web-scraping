class Article
    def initialize(title, subtitle, date, tags)
        @title = title
        @subtitle = subtitle
        @date = date
        @tags = tags
    end

    attr_reader :title
    attr_reader :subtitle
    attr_reader :date
    attr_reader :tags
end
