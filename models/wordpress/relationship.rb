module Wordpress
  class Relationship < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_term_relationships"
  end
end
