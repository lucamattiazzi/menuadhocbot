module Telegram
  class User < Telegram::Base
    self.table_name = "telegram_users"
    has_many :messages

    @@api = ::Telegram::Bot::Api.new(TELEGRAM_TOKEN)

    def incipit_response
      case
      when self[:requests_count] <= 1
        return "Benvenuto #{self[:first_name]}!\nEcco cosa ti propongo:\n"
      when self[:requests_count] <= 10
        return "Bentornato #{self[:first_name]}!\nEcco cosa ti propongo oggi:\n"
      else
        return "Un cliente abituale oramai, ciao #{self[:first_name]}!\nLe mie proposte sono:\n"
      end
    end

    def no_result_response
      return "Mi spiace #{self[:first_name]}, ma non ho trovato ricette con quest'ingrediente!\nEcco delle ricette che potresti provare:\n"
    end

    def update_recipe(post)
      self.update_attribute(:last_recipe_post_id, post[:ID])
      self.update_attribute(:last_recipe_post_request_date, Time.now)
      self.update_attribute(:last_recipe_post_duration, post.duration)
    end

    def self.check_and_remember
      users = self.where(last_recipe_post_feedback: 0).where("DATE_ADD(last_recipe_post_request_date, INTERVAL last_recipe_post_duration SECOND) <= NOW()")
      count = users.count
      users.each do |user|
        user.send_remind
      end
      return count
    end

    def send_remind
      post = ::Wordpress::Post.find_by_ID(self[:last_recipe_post_id])
      @@api.send_message(text: "Ehi! Hai preparato #{post[:post_title]}? Com'è andata??", chat_id: self[:telegram_id])
      self.update_attribute(:last_recipe_post_feedback, 1)
    end

  end
end
