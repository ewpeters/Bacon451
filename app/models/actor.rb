require 'pqueue'


class Node
  include Comparable
  attr_accessor :distance, :id
  def initialize(d, i)
    self.distance, self.id = d, i  
  end
  
  def <=>(other)
    other.distance <=> self.distance 
  end
end

class PQueue
  def self.reorder(queue)
    new_queue = PQueue.new
    queue.to_a.each do |element|
      new_queue.push element
    end
    return new_queue
  end
end
  
class Actor < ActiveRecord::Base
  has_and_belongs_to_many :movies

  # This is an implementaion of Dijkstra's algorithm the psuedo code can be found here: 
  # http://en.wikipedia.org/wiki/Dijkstra's_algorithm#Pseudocode
  def find_path(target)
    infinity = 999999999
    return 0 if self.id == target.id 
    redis = Redis.new(:host => "127.0.0.3")
    queue = PQueue.new

    # nodes hash to quickly find a node from an id and change to distance
    nodes = {}
    # Push every node in the graph onto the PQueue and put them in the nodes hash for easy lookup
    redis.smembers("all_actors").each do |actor|
      actor = actor.to_i
      node = Node.new(self.id == actor ? 0 : infinity, actor)
      nodes[actor] = node
      queue.push(node)
    end
    
    while queue.size != 0
      current = queue.pop
      # All remaining vertices are unreachable return Infinity
      if current.distance == infinity
        return 1.0/0
      end
      # We have reached our target return the distance
      if current.id == target.id
        return current.distance -= 1
      end
      
      # redis stores the set of all a given actors costars (neighbors) as :actor_id => [costar1, costar2]
      # iterate over them relaxing edges where necessary
      redis.smembers(current.id).each do |neighbor|
        alt = current.distance + 1
        # relax and reorder the queue
        if alt < nodes[neighbor.to_i].distance
          nodes[neighbor.to_i].distance = alt
          queue = PQueue.reorder(queue)
        end
      end
    end
  end
end
