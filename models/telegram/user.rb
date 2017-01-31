module Telegram
  class User < Telegram::Base
    self.table_name = "telegram_users"
    has_many :messages

    def incipit_response
      case
      when self[:requests_count] <= 1
        return "Benvenuto/a #{self[:first_name]}!\nEcco cosa ti propongo:\n"
      when self[:requests_count] <= 10
        return "Bentornato/a #{self[:first_name]}!\nEcco cosa ti propongo oggi:\n"
      else
        return "Un cliente abituale oramai, ciao #{self[:first_name]}!\nLe mie proposte sono:\n"
      end
    end

    def update_recipe(post)
      self.update_attribute(:last_recipe_post_id, post[:ID])
      self.update_attribute(:last_recipe_post_request_date, Time.now)
    end

  end
end
