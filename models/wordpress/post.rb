module Wordpress
  class Post < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_posts"

    def self.search_ingredients(words, conj = "AND")
      raw_sql = "SELECT post_excerpt, guid, post_title FROM #{self.table_name} WHERE post_type = 'post' AND ("
      words.each_with_index do |word, idx|
        raw_sql += "post_content LIKE '%#{word}%'"
        next if idx == (words.size - 1)
        raw_sql += " #{conj} "
      end
      raw_sql += ")"
      return self.find_by_sql(raw_sql).inject([]) do |res, post|
        res << {
          title: post[:post_title],
          url: post[:guid],
          recipe: post[:post_excerpt]
        }
      end
    end

  end
end
