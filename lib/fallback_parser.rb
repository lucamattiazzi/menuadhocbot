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
      brag_about_it(post[:post_title])
      return "Ecco la ricetta che hai scelto #{user[:first_name]}: [#{post[:post_title]}](#{post[:guid]})"
    else
      return "Basta importunarmi #{user[:first_name]}!"
    end
  end

  def brag_about_it(recipe_name)
    Thread.new do
      uri = URI("https://grokked.it/researched_recipe?recipe=#{recipe_name.gsub(' ', '%20')}")
      Net::HTTP.get(uri)
    end
  end

end
