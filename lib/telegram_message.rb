class TelegramMessage

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def save_and_return
    user_hash = @message["from"]
    text = @message["text"]
    user = Telegram::User.find_or_create_by(telegram_id: user_hash["id"])
    user.first_name = user_hash["first_name"]
    user.last_name = user_hash["last_name"]
    user.user_name = user_hash["username"]
    user.save
    user.messages.create(text: text)
    return user[:first_name]
  end

end
