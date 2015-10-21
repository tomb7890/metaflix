class MoviesController < ApplicationController
  def index
    @movie = Movie.new
    @movies = Movie.all
    @filteredmovies = Movie.metascore_sixty_or_higher.order(:created_at).reverse_order.page  params[:page]

    make_filtered_movie_dates
  end

  def create
    Movie.create(user_params)
    redirect_to :back
    # render :text => params.inspect
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    movie = Movie.find params[:id]
    if movie.update_attributes user_params # params[:movie]
      redirect_to movies_path, :notice => "Your movie has successfully been updated."
    else
      redirect_to :back, :notice => "There was an error updating your movie."
    end
  end

  def destroy
    Movie.destroy params[:id]
    redirect_to :back, :notice => 'Movie has been deleted.'
  end


private
  def user_params
    params.require(:movie).permit(:title, :description)
  end

  def make_filtered_movie_dates
    @filtered_movie_dates = Array.new
    @filteredmovies.each do | fm |
      moviedate = fm.created_at.to_date
      if not @filtered_movie_dates.include? moviedate
        @filtered_movie_dates.append( moviedate )
      end
    end
  end

end
