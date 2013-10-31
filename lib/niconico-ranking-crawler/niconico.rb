require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << "/lib/niconico-ranking-crawler"


class NicoNico
  class << self
    def retrieve_series_mylist_from_part_one
      mylists = []

      movies = PartOneMovie.order("publish_date DESC")

      series_mylist_ids = movies.map do |part_one_movie|
        part_one_movie.series_mylist
      end

      series_mylist_ids.each do |mylist_id|
        mylist_obj = NicoQuery.mylist mylist_id
        mylist = Mylist.new

        mylist.mylist_id = mylist_obj.mylist_id
        mylist.title = mylist_obj.title
        mylist.creator = mylist_obj.creator

        mylist.save
      end
    end
  end

end