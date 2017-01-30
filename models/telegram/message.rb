module Telegram
  class Message < Telegram::Base
    self.table_name = "telegram_messages"
    belongs_to :telegram_user
  end
end
