Thread.new do
  begin
    interval = 300
    loop do
      result = Telegram::User.check_and_remember
      open('./log/loop.log', 'a') do |f|
        f.puts "I just asked #{result} users about their recipes!"
      end
      sleep interval
    end
  rescue StandardError => e
    open('./log/loop.log', 'a') do |f|
      f.puts "Something went wrong: #{e}"
    end
  end
end
