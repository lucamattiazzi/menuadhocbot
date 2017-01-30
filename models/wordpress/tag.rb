module Wordpress
  class Tag < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_terms"
  end
end
