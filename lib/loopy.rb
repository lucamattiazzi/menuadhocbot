Thread.new do
  begin
    interval = 300
    loop do
      result = Telegram::User.check_and_remember
      if result > 0
        open('./log/loop.log', 'a') do |f|
          f.puts "I've remembered #{result} tasks to do!"
        end
      end
      sleep interval
    end
  rescue StandardError => e
    open('./log/loop.log', 'a') do |f|
      f.puts "Something went wrong: #{e}"
    end
  end
end
