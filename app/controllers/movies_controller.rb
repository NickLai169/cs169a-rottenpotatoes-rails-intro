class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    
    @conditional_movie_css = ""
    @conditional_release_date_css = ""
    
    
    if params[:ratings] == nil
#       @ratings_to_show = []
      @ratings_to_show = {'G': "1",'PG': "1",'PG-13': "1",'R': "1"}
      session[:ratings] = Hash[@ratings_to_show.map{|x| [x, 1]}]
      @movies = Movie.with_ratings(@ratings_to_show)
#       redirect_to movies_path(:ratings => session[:ratings], :sortby => params[:sortby])
    else
      session[:ratings] = params[:ratings]
      @ratings_to_show = params[:ratings]
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    
    
    
    if params[:sortby] == "release_date"
      session[:sortby] = params[:sortby]
      @conditional_release_date_css = "hilite text-light bg-warning"
      @movies = @movies.order(:release_date)
    end
    
    if params[:sortby] == "title"
      session[:sortby] = params[:sortby]
      @conditional_movie_css = "hilite text-light bg-warning"
      @movies = @movies.order(:title)
    end
    
    
    
        flash[:notice] = "#{@ratings_to_show}"
#     flash[:notice] = "#{params[:ratings]}"
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
