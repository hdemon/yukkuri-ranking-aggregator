require "nicoquery"
require "active_record"


class MovieLogs < ActiveRecord::Base
  belongs_to :movie
end
