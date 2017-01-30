module Telegram
  class User < Telegram::Base
    self.table_name = "telegram_users"
    has_many :messages
    def full_name
      return "#{self[:first_name]} #{self[:last_name]}"
    end
  end
end
