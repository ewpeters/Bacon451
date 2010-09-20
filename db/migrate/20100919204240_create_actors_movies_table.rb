class CreateActorsMoviesTable < ActiveRecord::Migration
  def self.up
  	create_table :actors_movies, :id => false do |t|
  		t.column :movie_id, :integer, :null => false
  		t.column :actor_id, :integer, :null => false
  	end
  end

  def self.down
  	drop_table :actors_movies
  end
end
