require "nicoquery"


module Crawler
  PART_ONE_TAG = "ゆっくり実況プレイpart1リンク or VOICEROID実況プレイPart1リンク"

  # ニコ動にはあるが、DB上にはまだ無い最新の動画を取得
  def get_latest_part1_movie_from_web
    Log.logger.info "Getting movies which has #{PART_ONE_TAG} tag is started."

    last_part_one = PartOneMovie.latest_archived_movie
  
    if last_part_one.present?
      Log.logger.info "The last part one movie is #{last_part_one.video_id} published at #{last_part_one.publish_date.to_s}."
    else
      Log.logger.info "There is no part one movie in DB."
    end

    NicoQuery.tag_search( tag: PART_ONE_TAG,
                          sort: :published_at,
                          order: :desc
                        ) do |result|

      if result.publish_date <= (last_part_one.try(:publish_date) || PartOneMovie::DummyOfEarliest.publish_date)
        Log.logger.info "Tag searching is terminated."
        return :break
      end

      Log.logger.info "Scraping #{result.video_id}"
      m = PartOneMovie.new
      m.video_id = result.video_id
      m.mylist_references = result.description.mylist_references.join(' ')
      m.publish_date = result.publish_date
      m.has_retrieved_series_mylist = false
      m.save
      Log.logger.info "#{result.video_id} is stored into DB."

      :continue
    end

    Log.logger.info "Getting movies which has #{PART_ONE_TAG} tag is completed."
  rescue => exception
    Log.logger.error exception
  end

  # それぞれの動画が持つマイリストから、シリーズをまとめたマイリストと認められるものを
  # 抽出し、series_mylist_idカラムに保存する。
  def retrieve_series_mylists
    Log.logger.info "Retrieving series mylists is started."
    mylists = []

    movies = PartOneMovie.where("has_retrieved_series_mylist = false OR has_retrieved_series_mylist IS NULL")
                         .order("publish_date DESC")

    series_mylist_ids_of(movies) do |part_one_movie|
      m = PartOneMovie.where(video_id: part_one_movie[:video_id]).first
      # TODO: カラム名をseries_mylist_idにする
      m.series_mylist = part_one_movie[:series_mylist_id]
      m.has_retrieved_series_mylist = true
      m.save
      Log.logger.info "Saving movie:#{m.series_mylist} as series mylist of #{part_one_movie[:video_id]} is completed successfully."
    end

    Log.logger.info "Retrieving series mylists is completed."
  rescue => exception
    Log.logger.error exception
  end

  def series_mylist_ids_of(movies, &block)
    movies.each do |part_one_movie|
      block.call({
        video_id: part_one_movie.video_id,
        series_mylist_id: part_one_movie.series_mylist_id
      })
    end
  end

  def get_series_mylists
    Log.logger.info "Getting series mylists is started."
    movies = PartOneMovie.movies_having_retrieved_series_mylist

    movies.each do |movie|
      next unless Mylist.where(mylist_id: movie.series_mylist).empty?

      ml = NicoQuery.mylist movie.series_mylist

      new_mylist = Mylist.new
      new_mylist.mylist_id = ml.mylist_id
      new_mylist.creator = ml.creator
      new_mylist.title = ml.title
      new_mylist.url = ml.url

      new_movies = []
      new_mylist_movies = []
      i = 0

      ml.movies.each do |movie|
        next if Movie.where(thread_id: movie.thread_id).present?

        new_movies[i] = Movie.new
        new_movies[i].video_id = movie.video_id
        new_movies[i].thread_id = movie.thread_id
        new_movies[i].url = movie.url
        new_movies[i].title = movie.title
        new_movies[i].description = movie.description
        new_movies[i].thumbnail_url = movie.thumbnail_url
        new_movies[i].publish_date = movie.publish_date
        new_movies[i].length = movie.length

        i += 1
      end
      
      ActiveRecord::Base.transaction do
        new_mylist.save unless Mylist.where(mylist_id: new_mylist.mylist_id).empty?

        new_movies.each do |movie| 
          movie.save

          mm = MylistMovie.new
          mm.movie_id = movie.id
          mm.mylist_id = new_mylist.id
          mm.save unless MylistMovie.where(mylist_id: new_mylist.id).where(movie_id: movie.id).empty?
        end
      end

      Log.logger.info "Saving mylist:#{new_mylist.mylist_id} and its movies into DB is completed successfully."
    end

    Log.logger.info "Getting series mylists is completed."
  rescue => exception
    Log.logger.error exception
  end

  def get_mutable_movie_info_of_all_mylists
    Log.logger.info "Getting movies info in all of stored mylists is started."

    Mylist.all.each do |mylist|
      Log.logger.info "target is mylist:#{mylist.mylist_id}"
      mylist_obj = NicoQuery.mylist mylist.mylist_id

      video_id_array = mylist_obj.movies.map(&:video_id)
      movies = NicoQuery.movie(video_id_array)

      movies.each do |movie|
        Log.logger.info "Start getting info of movie:#{movie.video_id}"
        movie_log = MovieLogs.new

        if Movie.where(video_id: movie.video_id).empty?
          Log.logger.info "Skipped saving movie log of movie:#{movie.video_id} because of non-existent movie info in movie table."
          next 
        end

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
        Log.logger.info "Completed getting info of movie:#{movie.video_id}"
      end
    end

    Log.logger.info "Getting movies info in all of stored mylists is completed." 
  rescue => exception
    Log.logger.error exception
  end

  module_function :get_latest_part1_movie_from_web
  module_function :retrieve_series_mylists
  module_function :series_mylist_ids_of
  module_function :get_series_mylists
  module_function :get_mutable_movie_info_of_all_mylists
end

