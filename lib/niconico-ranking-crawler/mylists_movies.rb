require "nicoquery"
require "active_record"


class MylistsMovies < ActiveRecord::Base
  belongs_to :movie
  belongs_to :mylist
end
