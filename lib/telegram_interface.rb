class TelegramInterface

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def save_and_return
    user_hash = @message["from"]
    text = @message["text"]
    return Telegram::User.find_or_create_by(telegram_id: user_hash["id"]) do |user|
      user.first_name = user_hash["first_name"]
      user.last_name = user_hash["last_name"]
      user.user_name = user_hash["username"]
      user.save
      user.messages.create(text: text)
    end
  end

  def update_and_return
    user_hash = @message["from"]
    user = Telegram::User.find_or_create_by(telegram_id: user_hash["id"])
    user.update_attribute(:requests_count, user[:requests_count] + 1)
    return user
  end

  def post_return
    id = @message["text"][1..-1]
    post = ::Wordpress::Post.find_by_ID(id)
    return post
  end

end
