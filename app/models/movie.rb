class Movie < ActiveRecord::Base
    def self.list_of_ratings
        @@ratings_list = self.select(:rating).distinct
        list_ratings = []
        @@ratings_list.each do |rating|
            list_ratings.push(rating.rating)
        end
        return list_ratings
    end
end
