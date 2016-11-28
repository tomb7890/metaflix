class MoviesController < ApplicationController
  def index
    make_filtered_movies
    make_filtered_movie_dates
  end

  private

  def make_filtered_movies
    good_movies = Movie.metascore_sixty_or_higher
    ordered_good = good_movies.order(:created_at).reverse_order
    @filteredmovies = ordered_good.page(params[:page])
  end

  def make_filtered_movie_dates
    @filtered_movie_dates = []
    @filteredmovies.each do |fm|
      moviedate = fm.created_at.to_date
      unless @filtered_movie_dates.include? moviedate
        @filtered_movie_dates.append(moviedate)
      end
    end
  end
end
