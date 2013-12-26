require "active_record"
require "nicoquery"
require "utils"
require 'log'


class PartOneMovie < ActiveRecord::Base
  scope :latest_archived_movie, -> {
    self.order("publish_date DESC").first
  }

  scope :movies_not_having_retrieved_series_mylist, -> {
    PartOneMovie.where(series_mylist: nil).order("publish_date DESC")
  }

  scope :movies_having_retrieved_series_mylist, -> {
    PartOneMovie.where("series_mylist IS NOT NULL")
  }

  class DummyOfEarliest < NicoQuery::Object::Movie
    def self.publish_date
      Time.local(2007, 3, 6, 0, 0, 0) # ニコニコ動画(β)のリリース日
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
    Log.logger.info "start retrieving series mylist from movie:#{self.video_id}"
    movie = NicoQuery::movie self.video_id
    return unless movie.available?
    mylists = referenced_mylists_in movie

    unless contain_part1? mylists
      Log.logger.info "movie:#{movie.video_id} doesn't contain series mylist."
      return
    end

    medians_of_levenshtein = mylists.map do |mylist|
      # 動画を含まないマイリストへの対応
      if mylist.movies.blank?
        median = 0
      else
        median = median_of_levenshtein_distances(from: mylist.movies, to: movie)
      end

      { mylist_id: mylist.mylist_id, median: median }
    end

    min = medians_of_levenshtein.min { |a, b| a[:median] <=> b[:median] }
    Log.logger.info "#{movie.video_id}: #{min[:mylist_id]} is series mylist."
    min[:mylist_id]
  end

  private

  def median_of_levenshtein_distances(from: nil, to: nil)
    Utils.median(Utils.levenshtein_distances(base_movies: from, target_movie: to))
  end

  def contain_part1?(mylists)
    return false if mylists.blank?

    mylists.map do |mylist|
      mylist.movies.map do |movie|
        unless movie.tags.blank?
          movie.tags.map { |tag| tag[:text] == "ゆっくり実況プレイpart1リンク" }
        else 
          [false]
        end.include? true
      end.include? true
    end.include? true
  end

  def referenced_mylists_in(movie)
    return [] if movie.description.nil?

    mylists = []
    # TODO: each_with_indexで書きなおす
    movie.description.mylist_references.each do |mylist_id|
      mylist = NicoQuery.mylist(mylist_id.to_i)

      return unless mylist.available?
      mylists.push mylist
    end
    mylists
  end

end
