require "nicoquery"
require "log"


module Crawler
  CONFIG = YAML.load_file("./config/config.yml")

  # ニコ動にはあるが、DB上にはまだ無い最新の動画を取得
  def self.get_latest_part1_movie_from_web
    Log.logger.info "Getting movies which has #{CONFIG["part_one_tag"]} tag is started."

    last_part_one = PartOneMovie.latest_archived_movie
    if last_part_one.present?
      Log.logger.info "The last part one movie is #{last_part_one.video_id} published at #{last_part_one.publish_date.to_s}."
    else
      Log.logger.info "There is no part one movie in DB."
    end

    NicoQuery.tag_search( tag: CONFIG["part_one_tag"],
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

    Log.logger.info "Getting movies which has #{CONFIG["part_one_tag"]} tag is completed."
  rescue => exception
    Log.logger.error exception
  end

  # それぞれの動画が持つマイリストから、シリーズをまとめたマイリストと認められるものを
  # 抽出し、series_mylist_idカラムに保存する。
  def self.retrieve_series_mylists
    Log.logger.info "Retrieving series mylists is started."
    mylists = []

    movies = PartOneMovie.where("has_retrieved_series_mylist = false OR has_retrieved_series_mylist IS NULL")
                         .order("publish_date DESC")

    series_mylist_ids_of(movies) do |part_one_movie|
      m = PartOneMovie.where(video_id: part_one_movie[:video_id]).first
      m.series_mylist_id = part_one_movie[:series_mylist_id]
      m.has_retrieved_series_mylist = true
      m.save
      Log.logger.info "Saving movie:#{m.series_mylist_id} as series mylist of #{part_one_movie[:video_id]} is completed successfully."
    end

    Log.logger.info "Retrieving series mylists is completed."
  rescue => exception
    Log.logger.error exception
  end

  def self.series_mylist_ids_of(movies, &block)
    movies.each do |part_one_movie|
      block.call({
        video_id: part_one_movie.video_id,
        series_mylist_id: part_one_movie.retrieved_series_mylist_id
      })
    end
  end

  def self.get_series_mylists
    Log.logger.info "Getting series mylists is started."
    movies = PartOneMovie.movies_having_retrieved_series_mylist

    movies.each do |movie|
      next if Mylist.where(mylist_id: movie.series_mylist_id).present?

      ml = NicoQuery.mylist movie.series_mylist_id

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
        new_mylist.save if Mylist.where(mylist_id: new_mylist.mylist_id).empty?

        new_movies.each do |movie|
          movie.save

          mm = MylistsMovies.new
          mm.movie_id = movie.id
          mm.mylist_id = new_mylist.id

          mm.save if MylistsMovies.where(mylist_id: new_mylist.id).where(movie_id: movie.id).empty?
        end
      end

      Log.logger.info "Saving mylist:#{new_mylist.mylist_id} and its movies into DB is completed successfully."
    end

    Log.logger.info "Getting series mylists is completed."
  rescue => exception
    Log.logger.error exception
  end

  def self.get_mutable_movie_info_of_all_mylists
    Log.logger.info "Getting movies info in all of stored mylists is started."

    Mylist.all.each do |mylist|
      Log.logger.info "target is mylist:#{mylist.mylist_id}"
      mylist_obj = get_mylist_obj mylist.mylist_id

      video_id_array = mylist_obj.movies.map(&:video_id)
      movies = get_movie_obj video_id_array

      movies.each do |movie|
        Log.logger.info "Start getting info of movie:#{movie.video_id}"

        if Movie.where(video_id: movie.video_id).empty?
          Log.logger.info "Skipped saving movie log of movie:#{movie.video_id} because of non-existent movie info in movie table."
          next
        end

        save_tags_of movie
        save_logs_of movie

        counter = 1

        Log.logger.info "Completed getting info of movie:#{movie.video_id}"
      end
    end

    Log.logger.info "Getting movies info in all of stored mylists is completed."
  rescue => exception
    Log.logger.error exception
  end

  def self.get_mylist_obj mylist_id
    NicoQuery.mylist mylist_id
  rescue => exception
    Log.logger.error exception
    counter += 1
    sleep 180
    Log.logger.info "Retry getting mylist info"
    retry until counter < 6
  end

  def self.get_movie_obj video_id_array
    NicoQuery.movie video_id_array
  rescue => exception
    Log.logger.error exception
    counter += 1
    sleep 180
    Log.logger.info "Retry getting movie info"
    retry until counter < 6
  end

  def self.save_tags_of movie
    movie.tags.each do |tag|
      if Tag.where(text: tag[:text]).empty?
        new_tag = Tag.new
        new_tag.text = tag[:text]
        new_tag.save
      else
        next
      end
    end
  end

  def self.save_logs_of movie
    now = Time.now
    movie_log = MovieLog.new
    movie_log.movie_id = Movie.where(video_id: movie.video_id).first.id
    movie_log.view_counter = movie.view_counter
    movie_log.mylist_counter = movie.mylist_counter
    movie_log.comment_num = movie.comment_num
    movie_log.created_at = now
    movie_log.save

    movie.tags.each do |tag|
      movie_log_tag = MovieLogsTags.new
      movie_log_tag.tag_id = Tag.where(text: tag[:text]).first.id
      movie_log_tag.movie_log_id = movie_log.id
      movie_log_tag.created_at = now
      movie_log_tag.save
    end
  end
end
