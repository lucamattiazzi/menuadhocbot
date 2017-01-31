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
