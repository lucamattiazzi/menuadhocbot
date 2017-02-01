module Wordpress
  class Relationship < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_term_relationships"
    belongs_to :post, foreign_key: :object_id
    belongs_to :taxonomy, foreign_key: :term_taxonomy_id
  end
end
