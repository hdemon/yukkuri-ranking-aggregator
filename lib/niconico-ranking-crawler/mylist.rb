require "nicoquery"
require "movie_logs"
require "active_record"


class Mylist < ActiveRecord::Base
  has_many :mylist_movies
  has_many :movies, through: :mylist_movies
end
