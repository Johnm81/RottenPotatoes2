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
    @movies = Movie.all
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    
    
    
    
    sort = params[:sort] || session[:sort]
    ratings = params[:ratings] || session[:ratings]
    
    if params[:sort] == "title"
      @title_header = "hilite"
    else
      @title_header= ""
    end
    if params[:sort] == "release_date"
      @release_date_header = "hilite"
    else
      @release_date_header = ""
    end
    
    
    if (params[:sort] != session[:sort]) || (params[:ratings] != session[:ratings])
      session[:sort] = sort
      session[:ratings] = ratings
      redirect_to :sort => sort, :ratings => ratings and return
      
    else
      
      @movies = Movie.all
      
    end
    
    @selected_ratings = @all_ratings
    
    if params[:ratings].nil?
      Movie.order(params[:sort])
    else
      @selected_ratings = params[:ratings].keys
      @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort])
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
