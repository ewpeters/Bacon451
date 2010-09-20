class Movie < ActiveRecord::Base
	has_and_belongs_to_many :actors
	
	# ping the moviedb api again to add actors for a movie in sql
	# and store the actors co stars in redis
	def addActors(imdb_id)
	  redis = Redis.new(:host => "127.0.0.3")
	  
    doc = Nokogiri::XML(open("http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/89064d9f8b5af92d29e719ba32515770/#{imdb_id}"))
    
    actors = doc.xpath("//cast/person[@job='Actor']")
    actors_ids = []
    actors.each do |a|
      actor = Actor.find_or_create_by_name(a.attr('name'))
      actors_ids << actor.id
      self.actors << actor
    end
    
    # All the actor ids will be in redis so that the key to the set is the actor's id
    # and the set is the ids of all the actors they have been in a movie with
    actors_ids.each do |a|
      redis.sadd "all_actors", a 
      actors_ids.each do |ia|
        redis.sadd a, ia if a != ia
      end
    end
    self.save!
  end
end
