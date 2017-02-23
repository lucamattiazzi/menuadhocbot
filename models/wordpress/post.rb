module Wordpress
  class Post < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_posts"
    has_many :relationships, foreign_key: :object_id
    has_many :taxonomies, through: :relationships
    has_many :tags, through: :taxonomies

    def self.recipes
      Wordpress::Tag.find_by_name("Bot").posts
    end

    def self.search_ingredients(course, words, disj, conj = "AND")
      posts = self.recipes
      words.each do |word|
        posts = posts.where("LOWER(post_content) LIKE '%#{word.downcase}%'")
      end
      return posts.inject([]) do |res, post|
        res << {
          id: post[:ID],
          title: post[:post_title]
        }
      end
    end

    def self.random_recipes
      raw_sql = "SELECT ID, post_title FROM #{self.table_name}  ORDER BY RAND() LIMIT 8"
      return self.recipes.find_by_sql(raw_sql).inject([]) do |res, post|
        res << {
          id: post[:ID],
          title: post[:post_title]
        }
      end
    end

    def duration
      times = /tempo\s*:\s*([0-9]+)?([a-z]+)?([0-9]+)?([a-z]+)?/.match(self[:post_excerpt].downcase)
      return 3601 unless times
      times[1..-1].compact.each_slice(2).inject(0) do |sum, time|
        amount = time[0].to_i
        unit = time[1]
        multiplier = case unit
        when "s"
          1
        when "min" || "m"
          60
        when "h" || "ore" || "ora"
          3600
        else
          0
        end
        sum += amount * multiplier
      end
    end

  end
end
