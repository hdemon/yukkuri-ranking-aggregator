require "active_record"
require "nicoquery"


class PartOneMovie < ActiveRecord::Base
  PART_ONE_TAG = "ゆっくり実況プレイpart1リンク or VOICEROID実況プレイPart1リンク"

  class DummyOfEarliest < NicoQuery::Object::Movie
    def publish_date
      Time.local(2007, 3, 6, 0, 0, 0) # ニコニコ動画(β)のリリース日
    end
  end

  class << self
     # DB中の最新の動画を取得
    def get_latest_archived_movie
      movie = self.order("publish_date DESC").first
      if movie.nil?
        pp "there is no movie in DB."
        nil
      else
        pp "The last part one movie is #{movie.video_id} published at #{movie.publish_date.to_s}."
        movie
      end
    end

    # ニコ動にはあるが、DB上にはまだ無い最新の動画を取得
    def acquire_latest_movie
      # crawler_proxy = crawler_proxy()
      last_part_one = self.get_latest_archived_movie

      NicoQuery.tag_search( tag: PART_ONE_TAG,
                            sort: :published_at,
                            order: :desc
                          ) do |result|

        return :break if result.publish_date <= last_part_one.publish_date

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
    rescue => exception
      puts exception
    end

    # part 1の動画とその他の動画の組み合わせにおいて、タイトルの編集距離を測る。
    #
    # @param  mylist [Mylist] Mylist instance that includes part one movie
    # @param  part_one_movie [Movie] Movie instance of part one movie
    #
    # @return [Array] an array includes the number of levenshtein distance from part one movie
    # to each movie in the same mylist.
    def levenshtein_distances_in(mylist, part_one_movie)
      mylist.movies.map do |movie|
        levenshtein part_one_movie.title, movie.title
      end
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
  def series_mylist
    movie = NicoQuery::movie self.video_id
    mylists = referenced_mylists_in movie

    medians = mylists.map do |mylist|
      {
        mylist_id: mylist.mylist_id,
        median: PartOneMovie.median(PartOneMovie.levenshtein_distances_in(mylist, movie))
      }
    end

    min = medians.min { |a, b| a[:median] <=> b[:median] }
    min[:mylist_id]
  end

  private
  def referenced_mylists_in(movie)
    mylists = []
    movie.description.mylist_references.each do |mylist_id|
      mylists.push NicoQuery.mylist(mylist_id.to_i)
    end
    mylists
  end

end
