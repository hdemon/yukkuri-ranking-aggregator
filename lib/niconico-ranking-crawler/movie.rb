require "nicoquery"
require "active_record"


class Movie < ActiveRecord::Base
  has_many :mylist_movies
  has_many :movie_logs
  has_many :mylists, through: :mylist_movies
end
