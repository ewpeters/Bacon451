class ActorController < ApplicationController
  def find_path
    actor_one = Actor.find_by_id(params[:actor_one][:id])
    actor_two = Actor.find_by_id(params[:actor_two][:id])
    
    flash[:actor_one] = actor_one.name
    flash[:distance]  = actor_one.find_path(actor_two)
    flash[:actor_two] = actor_two.name
    redirect_to :controller => "actor", :action => "index"
  end
end
