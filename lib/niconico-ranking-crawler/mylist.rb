require "nicoquery"
require "movie_logs"
require "active_record"


class Mylist < ActiveRecord::Base
  has_many :mylist_movies
  has_many :movies, through: :mylist_movies

  class << self
    def get_mutable_movie_info_of_all_mylists
      Mylist.all.each do |mylist|
        m = NicoQuery.mylist mylist.mylist_id

        video_id_array = m.movies.map(&:video_id)
        movies = NicoQuery.movie(video_id_array)

        movies.each do |movie|
          movie_log = MovieLogs.new

          movie_log.movie_id = Movie.where(video_id: movie.video_id).first.id
          movie_log.view_counter = movie.view_counter
          movie_log.mylist_counter = movie.mylist_counter
          movie_log.comment_num = movie.comment_num

          counter = 1
          movie.tags.each do |tag|
            movie_log.send("tag_#{counter}=", tag[:text])
            counter += 1
          end

          movie_log.save
        end
      end
    end
  end
end
