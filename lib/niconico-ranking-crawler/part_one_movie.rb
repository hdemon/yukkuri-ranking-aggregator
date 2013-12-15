require "active_record"
require "nicoquery"
require 'log'


class PartOneMovie < ActiveRecord::Base
  PART_ONE_TAG = "ゆっくり実況プレイpart1リンク or VOICEROID実況プレイPart1リンク"

  class DummyOfEarliest < NicoQuery::Object::Movie
    def self.publish_date
      Time.local(2007, 3, 6, 0, 0, 0) # ニコニコ動画(β)のリリース日
    end
  end

  class << self
     # DB中の最新の動画を取得
    def get_latest_archived_movie
      movie = self.order("publish_date DESC").first
      if movie.nil?
        Log.logger.info "there is no movie in DB."
        nil
      else
        Log.logger.info "The last part one movie is #{movie.video_id} published at #{movie.publish_date.to_s}."
        movie
      end
    rescue => exception
      Log.logger.error exception
    end

    # ニコ動にはあるが、DB上にはまだ無い最新の動画を取得
    def get_latest_part1_movie_from_web
      Log.logger.info "start crawling movie which has #{PART_ONE_TAG} tag."
      # crawler_proxy = crawler_proxy()
      last_part_one = self.get_latest_archived_movie

      NicoQuery.tag_search( tag: PART_ONE_TAG,
                            sort: :published_at,
                            order: :desc
                          ) do |result|

        Log.logger.info "get #{result.video_id}"

        if result.publish_date <= (last_part_one.try(:publish_date) || DummyOfEarliest.publish_date)
          Log.logger.info "tag searching is terminated"
          return :break
        end

        # TODO 取得動画数が100に満たない時の処理をどうするか、検討する。
        # crawler_proxy.call 100, result do |movie_array|
          # movie_array.each do |elem|
            m = self.new
            m.video_id = result.video_id
            # TODO: pgの配列型を利用する方法を検討。
            m.mylist_references = result.description.mylist_references.join(' ')
            m.publish_date = result.publish_date

            m.save
          # end
        # end

        :continue
      end

      Log.logger.info "crawling movie which has #{PART_ONE_TAG} tag is finished."
    rescue => exception
      Log.logger.error exception
    end

    # それぞれの動画が持つマイリストから、シリーズをまとめたマイリストと認められるものを
    # 抽出し、series_mylist_idカラムに保存する。
    def retrieve_series_mylist
      Log.logger.info "start retrieving series mylists."
      mylists = []
      movies = PartOneMovie.order("publish_date DESC")

      series_mylist_ids_of(movies).each do |part_one_movie|
        Log.logger.info "retrieving series mylists in #{part_one_movie[:video_id]}."
        m = PartOneMovie.where(video_id: part_one_movie[:video_id]).first
        # TODO: カラム名をseries_mylist_idにする
        m.series_mylist = part_one_movie[:series_mylist_id]
        m.save
      end

      Log.logger.info "retrieving series mylists is finished."
    rescue => exception
      Log.logger.error exception
    end

    def series_mylist_ids_of(movies)
      @cache ||= movies.map do |part_one_movie|
        {
          video_id: part_one_movie.video_id,
          series_mylist_id: part_one_movie.series_mylist_id
        }
      end
    end

    # part 1の動画とその他の動画の組み合わせにおいて、タイトルの編集距離を測る。
    #
    # @param  mylist [Mylist] Mylist instance that includes part one movie
    # @param  part_one_movie [Movie] Movie instance of part one movie
    #
    # @return [Array] an array includes the number of levenshtein distance from part one movie
    # to each movie in the same mylist.
    def levenshtein_distances(base_movies: nil, target_movie: nil)
      base_movies.map { |movie| levenshtein target_movie.title, movie.title }
    end

    def levenshtein(a, b)
      (0..a.size).inject([[*0..b.size+1]]){|d, i|
        d << (0..b.size).inject([i+1]){|_d, j|
          _d << [
            d[i][j+1] + 1,
            _d[j] + 1,
            d[i][j] + (a[i]==b[j] ?0:1)
          ].min
        }
      }[-1][-1]
    end

    def median(array)
      sorted = array.sort
      len = sorted.length
      return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end
  end

  def mylist_references_array
    self.mylist_references.split(' ').map(&:to_i)
  end

  # Retrieve the mylist that is the smallest average of levenshtein distance in the description,
  # and return its id.
  #
  # @return [Integer] mylist_id
  def series_mylist_id
    movie = NicoQuery::movie self.video_id
    mylists = referenced_mylists_in movie

    unless contain_part1? mylists
      Log.logger.info "#{movie.video_id}: this movie doesn't contain series mylist."
      return
    end

    medians_of_levenshtein = mylists.map do |mylist|
      0 if mylist.movies.empty?
      {
        mylist_id: mylist.mylist_id,
        median: median_of_levenshtein_distances(from: mylist.movies, to: movie)
      }
    end

    min = medians_of_levenshtein.min { |a, b| a[:median] <=> b[:median] }
    min[:mylist_id]
  end

  private

  def median_of_levenshtein_distances(from: nil, to: nil)
    PartOneMovie.median(PartOneMovie.levenshtein_distances(base_movies: from, target_movie: to))
  end

  def contain_part1?(mylists)
    mylists.map do |mylist|
      mylist.movies.map do |movie|
        movie.tags.map do |tag|
          tag[:text] == "ゆっくり実況プレイpart1リンク"
        end.include? true
      end.include? true
    end.include? true
  end

  def referenced_mylists_in(movie)
    mylists = []
    movie.description.mylist_references.each do |mylist_id|
      mylist = NicoQuery.mylist(mylist_id.to_i)

      return unless mylist.available?
      mylists.push mylist
    end
    mylists
  end

end
