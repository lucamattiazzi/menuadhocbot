module Wordpress
  class Tag < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_terms"

    has_many :taxonomies, foreign_key: :term_id
    has_many :posts, through: :taxonomies

  end
end
