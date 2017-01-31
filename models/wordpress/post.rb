module Wordpress
  class Post < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_posts"

    def self.search_ingredients(course, words, disj, conj = "AND")
      raw_sql = "SELECT ID, post_title FROM #{self.table_name} WHERE post_type = 'post' AND ("
      words.each_with_index do |word, idx|
        raw_sql += "post_content LIKE '%#{word}%'"
        next if idx == (words.size - 1)
        raw_sql += " #{conj} "
      end
      raw_sql += ")"
      return self.find_by_sql(raw_sql).inject([]) do |res, post|
        res << {
          id: post[:ID],
          title: post[:post_title]
        }
      end
    end

  end
end
