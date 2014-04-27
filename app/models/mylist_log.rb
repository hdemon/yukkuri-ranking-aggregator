class MylistLog < ActiveRecord::Base

  def self.delta from, to
    { view: 100 }
  end
end
