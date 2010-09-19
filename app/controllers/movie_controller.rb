class MovieController < ApplicationController
  def index
    @movies = Movie.find(:all)
  end
end
