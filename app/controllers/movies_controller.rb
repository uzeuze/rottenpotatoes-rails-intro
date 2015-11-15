class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @checked = {'G' => true, 'PG' => true, 'PG-13' => true, 'R' => true}

    if params[:ratings] || session[:ratings]
      session[:ratings] = params[:ratings] if params[:ratings]
      @movies= Movie.where(rating: session[:ratings].keys)
      @all_ratings.each do |r|
        if session[:ratings].keys.include? r 
           @checked[r] = true
        else
           @checked[r] = false
        end
      end
    else
      session[:ratings] = @all_ratings
      @movies = Movie.all
    end
   
    if params[:sort] == "title"
      @movies = Movie.where(rating: session[:ratings].keys).order(title: :asc)
      @title = "hilite"
    elsif params[:sort] == "release_date"
      @movies = Movie.where(rating: session[:ratings].keys).order(release_date: :asc)
      @release_date = "hilite"
    else
      @movies
    end
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

end
