module Wordpress
  class Post < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_posts"

    def self.search_ingredients(words, conj = "AND")
      raw_sql = "SELECT post_excerpt, guid FROM #{self.table_name} WHERE post_type = 'post' AND ("
      words.each_with_index do |word, idx|
        raw_sql += "post_content LIKE '%#{word}%'"
        next if idx == (words.size - 1)
        raw_sql += " #{conj} "
      end
      raw_sql += ")"
      return self.find_by_sql(raw_sql)
    end

    def self.filter(what, how)
      case what.downcase
      when "tag"
      when "taxonomy"
      else
        return all
      end
    end

    def self.sort_results(results)
      results.inject({}){|counter, result|}
      results.each_with_object({}){|n, r| r[n] ||= 0; r[n] += 1  }.sort_by{|k, v| -v }
    end

  end
end
