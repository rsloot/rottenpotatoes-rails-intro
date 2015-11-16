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
    # session.clear
    if params[:sort].nil?
      sort = session[:sort]
      params[:sort] = sort
    else
      params[:sort]
      session.delete(:sort)
    end
    
    # if params[:order].nil? 
    #   params[:order] = order
    # end
    sort = params[:sort]
    order = params[:order]
    @order = (order.nil? || order == 'desc') ? 'asc' : 'desc'

    @all_ratings = Movie.all_ratings
    ratings = params[:ratings]
    if ratings.nil?
      if session[:ratings].nil?
        @ratings = Movie.all_ratings
      else
        @ratings = session[:ratings]
      end
    else
      @ratings = ratings.keys
      session.delete(:ratings)
    end
    session[:order] = @order
    session[:sort] = sort
    session[:ratings] = @ratings
    @movies = Movie.order("#{sort} #{order}").where('rating IN (?)', @ratings).all
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
