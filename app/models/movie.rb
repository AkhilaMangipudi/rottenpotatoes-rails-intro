class Movie < ActiveRecord::Base
    def self.list_of_ratings
    ratings_list = []
    Movie.all.each do |movie|
      if (ratings_list.find_index(movie.rating) == nil)
        ratings_list.push(movie.rating)
      end
    end
    return ratings_list
    end
end
