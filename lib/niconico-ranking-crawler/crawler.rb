require "nicoquery"


$logger = Logger.new STDOUT
$logger.level = Logger::INFO

module Crawler
  PART_ONE_TAG = "ゆっくり実況プレイpart1リンク or VOICEROID実況プレイPart1リンク"

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

  # それぞれの動画が持つマイリストから、シリーズをまとめたマイリストと認められるものを
  # 抽出し、series_mylist_idカラムに保存する。
  def retrieve_series_mylist
    $logger.info "start retrieving series mylists."
    mylists = []

    # where.not(hoge: true)としたいが、その場合hoge: nilが感知されない。
    movies = PartOneMovie.where(series_mylist: nil).order("publish_date DESC")

    series_mylist_ids_of(movies) do |part_one_movie|
      m = PartOneMovie.where(video_id: part_one_movie[:video_id]).first
      # TODO: カラム名をseries_mylist_idにする
      m.series_mylist = part_one_movie[:series_mylist_id]
      m.save
      $logger.info "saved movie:#{m.series_mylist} as series mylist of #{part_one_movie[:video_id]}."
    end

    $logger.info "retrieving series mylists is finished."
  rescue => exception
    $logger.error exception
  end

  def series_mylist_ids_of(movies, &block)
    movies.each do |part_one_movie|
      block.call({
        video_id: part_one_movie.video_id,
        series_mylist_id: part_one_movie.series_mylist_id
      })
    end
  end

  # ニコ動にはあるが、DB上にはまだ無い最新の動画を取得
  def get_latest_part1_movie_from_web
    $logger.info "start crawling movie which has #{PART_ONE_TAG} tag."

    last_part_one = PartOneMovie.latest_archived_movie
  
    if last_part_one.nil?
      $logger.info "There is no part one movie in DB."
    else
      $logger.info "The last part one movie is #{last_part_one.video_id} published at #{last_part_one.publish_date.to_s}."
    end

    NicoQuery.tag_search( tag: PART_ONE_TAG,
                          sort: :published_at,
                          order: :desc
                        ) do |result|

      $logger.info "scrape #{result.video_id}"
      if result.publish_date <= (last_part_one.try(:publish_date) || PartOneMovie::DummyOfEarliest.publish_date)
        $logger.info "tag searching is terminated"
        return :break
      end

      m = PartOneMovie.new
      m.video_id = result.video_id
      m.mylist_references = result.description.mylist_references.join(' ')
      m.publish_date = result.publish_date
      m.save

      :continue
    end

    $logger.info "Crawling movie which has #{PART_ONE_TAG} tag is finished."
  rescue => exception
    $logger.error exception
  end

  module_function :get_mutable_movie_info_of_all_mylists
  module_function :get_latest_part1_movie_from_web
end

