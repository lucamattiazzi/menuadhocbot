module Telegram
  class Base < ActiveRecord::Base
    self.abstract_class = true
    establish_connection ActiveRecord::Base.configurations[:telegram]
  end
end
