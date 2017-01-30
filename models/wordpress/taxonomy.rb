module Wordpress
  class TermAttribute < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_term_taxonomy"
  end
end
