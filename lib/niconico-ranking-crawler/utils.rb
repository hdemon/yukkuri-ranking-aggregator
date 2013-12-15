module Utils
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

  module_function :levenshtein_distances
  module_function :levenshtein
  module_function :median
end