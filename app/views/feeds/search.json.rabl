object false
node :photos do 
  @search_results.map do |item|
    { 
      thumbnail: item["images"]["thumbnail"]["url"],
      standard_resolution: item["images"]["standard_resolution"]["url"],
      lat: item["location"]["latitude"],
      lng: item["location"]["longitude"],
      location_name: item["location"]["name"],
    }
  end
end