class InstagramService
  include HTTParty
  base_uri "https://api.instagram.com/v1/media"
  SEARCH_PATH = '/search'
  TOTAL_ITEMS = 100
  def self.media_search params
    return unless params
    params = params.merge!(count: TOTAL_ITEMS)
    opt = { query: params }
   # Rails.logger.info opt
    response = HTTParty.get(base_uri+SEARCH_PATH, opt)
    if response.code == 200
      JSON(response.body)["data"]
    else
      Rails.logger.error "Request failed"
      raise InstagramRequestError, "Failed request to Instagram"
    end
  end
end
class InstagramRequestError < StandardError; end