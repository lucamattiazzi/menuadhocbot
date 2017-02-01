module Wordpress
  class Taxonomy < Wordpress::Base
    self.table_name = "#{ENV['WORDPRESS_PREFIX']}_term_taxonomy"
    has_many :relationships, foreign_key: :term_taxonomy_id
    has_many :posts, through: :relationships
    belongs_to :tag, foreign_key: :term_id

  end
end
