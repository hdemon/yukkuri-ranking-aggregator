require "nicoquery"
require "active_record"


class MovieLog < ActiveRecord::Base
  belongs_to :movie
  has_many :movie_log_tags
  has_many :tags, through: :movie_log_tags
end
