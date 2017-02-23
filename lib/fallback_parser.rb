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
      brag_about_it(post)
      return "Ecco la ricetta che hai scelto #{user[:first_name]}: [#{post[:post_title]}](#{post[:guid]})"
    else
      return "Mi spiace, non ho capito #{user[:first_name]}!"
    end
  end

  def brag_about_it(post)
    Thread.new do
      uri = URI("https://grokked.it/researched_recipe?recipe=#{post[:post_title].gsub(' ', '%20')}&url=#{post[:guid]}")
      Net::HTTP.get(uri)
    end
  end

end
