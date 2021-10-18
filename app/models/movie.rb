class Movie < ActiveRecord::Base
  @all_ratings = ['G','PG','PG-13','R']
  
  def self.all_ratings
    return @all_ratings
  end
  
  def self.with_ratings(ratings_list)
    if ratings_list.length == 0
      return self.all_ratings
    else
      return where(rating: ratings_list.keys)
#       return where(rating: ratings_list)
    end
  end
end
