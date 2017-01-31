class FallbackParser

  attr_accessor :message, :request

  def initialize(message)
    @message = message
    @request = get_request
  end

  def get_request
    return TelegramInterface.new(@message["originalRequest"]["data"]["message"])
  end

  def parse
    user = @request.update_and_return
    post = @request.post_return
    if post
      user.update_recipe(post)
      return "Ecco la ricetta che hai scelto #{user[:first_name]}: [#{post[:post_title]}](#{post[:guid]})"
    else
      return "Basta importunarmi #{user[:first_name]}!"
    end
  end

end
