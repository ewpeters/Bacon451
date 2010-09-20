require 'open-uri'

class MovieController < ApplicationController
  def index
    @movies = Movie.find(:all)
  end

  def create
    new_movie = Movie.search_movie_db(params[:movie][:name], params[:movie][:year])
    if new_movie.nil?
      flash[:notice] = "Your search returns no results, try again"
      redirect_to :controller => "movie", :acton => "index"
    end
    redirect_to :controller => "movie", :action => "index"
  end
end
