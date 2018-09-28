class Movie < ActiveRecord::Base
    def self.list_of_ratings
    ratings_all = []
    Movie.all.each do |movie|
      if (ratings_all.find_index(movie.rating) == nil)
        ratings_all.push(movie.rating)
      end
    end
    return ratings_all
    end
end
