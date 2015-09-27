class FeedsController < ApplicationController
  before_filter :auth_instagram
  
  def index
    return unless search_params.size > 0
    param = search_params.merge!({ access_token: session[:access_token] })
    res = InstagramService.media_search(param)
    @res = res.select { |item| item["type"]=="image"}
    @photos = Gmaps4rails.build_markers(@res) do |instagram, marker|
      if instagram["location"]
        marker.lat instagram["location"]["latitude"]
        marker.lng instagram["location"]["longitude"]
        marker.infowindow instagram["location"]["name"]
      end
    end
  end
  
  private
  def auth_instagram
  	redirect_to session_connect_path if !session[:access_token]
  end

  def search_params
    params.permit(:lat, :lng, :distance)
  end
end
