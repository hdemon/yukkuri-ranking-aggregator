require "nicoquery"
require "active_record"


class MylistMovie < ActiveRecord::Base
  belongs_to :movie
  belongs_to :mylist
end
