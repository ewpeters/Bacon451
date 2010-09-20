require 'open-uri'

class MovieController < ApplicationController
  def index
    @movies = Movie.find(:all)
  end
  
  # Create pings the movie db api for the movie name in params and stores the info locally
  # TODO: re-evaluate whether this code belongs here or in the model
  def create
    @movie_name = params[:movie][:name]
    movie_year  = params[:movie][:year] if params[:movie][:year] == nil
     
    doc = Nokogiri::XML(open("http://api.themoviedb.org/2.1/Movie.search/en/xml/89064d9f8b5af92d29e719ba32515770/#{@movie_name.gsub(/ /, '+')}+#{movie_year}"))
    results = doc.xpath("//opensearch:totalResults").text.to_i
    movie = doc.xpath("//movie")
    
    if results == 0 
      flash[:notice] = "Your search returns no results, try again"
      redirect_to :controller => "movie", :acton => "index"
    else
      imdb_id         = movie.first.search("id").text
      @movie_desc     = movie.first.search("overview").text
      @movie_released = Date.parse(movie.first.search("released").text)
      movie_year    ||= @movie_released.year
      
      
      new_movie = Movie.find_or_create_by_name_and_year(:name => @movie_name, :year => movie_year)
      new_movie.addActors(imdb_id)
      redirect_to :controller => "movie", :action => "index"
    end
  end
end
