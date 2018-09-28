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
    #when we newly open a window, we don't know if we are opening it for the first time, or if we are opening it from an already opened window.
    # if we are opening from an already opened window, we should have some constraints which we set earlier, and we use session hash to restore the value
    if(params[:order].nil? && params[:ratings].nil? && (!session[:order].nil? || !session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(:order => session[:order], :ratings => session[:ratings]) and return 
    end 
    
    @title_hilite = session[:title_hilite] = "hilite" if params[:order] == 'title'
    @date_hilite = session[:date_hilite] = "hilite" if params[:order] == 'release_date'
    
    
    @ratings = params[:ratings]
    #Get list of ratings from the model
    ratings_list = Movie.list_of_ratings
  
    #The unchecked box movies should not be considered; i.e. when @ratings is not NIL, then we have a specific set of movies to consider, in the other case consider all the movies
    if !@ratings.nil?
      ratings_chosen = @ratings.keys
    else 
      ratings_chosen = ratings_list.to_enum  
    end
    
    @ratings_all = Hash.new
    
    ratings_list.each do |rating|
      @ratings_all[rating] = @ratings.nil? ? true : @ratings.has_key?(rating)
    end
    
    #Ordering should still be preserved even after adding the checkboxes for ratings.
    @order_by = params[:order]
    if !@order_by.nil?
      @movies = Movie.where('rating in (?)', ratings_chosen).order("#{@order_by}").all
    else
      @movies = Movie.where('rating in (?)', ratings_chosen)
    end 
    
    #this part is to remember the constraints set
    session[:order] = @order_by
    session[:ratings] = @ratings
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
