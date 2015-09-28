class FeedsController < ApplicationController
 
  def index
  end

  def search
    param = search_params.merge!({ client_id: CLIENT_ID })
    results = InstagramService.media_search(param)
    @search_results = results.select { |item| item["type"]=="image"}
   end
  
  private
  def search_params
    params.permit(:lat, :lng, :distance)
  end
end
