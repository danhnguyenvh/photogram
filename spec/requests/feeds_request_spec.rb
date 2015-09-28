require "rails_helper"

describe "Feeds Request" do
  describe '#search' do
    let(:data) do
      [{
        "type"=> "image",
        "location" => {
            "latitude"=> 48.8731995,
            "name"=> "Galeries Lafayette Haussmann",
            "longitude"=> 2.3324201
        },
        "images"=> {
            "low_resolution"=> { "url"=> "https://hphotos-xaf1/t51.2885-15/s320x320e35/672804397_517205638_n.jpg" },
            "thumbnail"=> { "url"=> "https://hphotos-xaf1/t51.2885-15/s150x150/e35/672804397_517205638_n.jpg" },
            "standard_resolution"=> { "url" => "https://hphotos-xaf1/t51.2885-15/e35/672804397_517205638_n.jpg" }
        }
      }]
    end
    before do
      allow(InstagramService).to receive(:media_search).and_return data
  	  get feeds_search_url(format: :json,
                          lat: data[0]["location"]["latitude"],
                          lng: data[0]["location"]["longitude"])
    end
    
    subject { response }

    it "response photos info after success request" do
      json = JSON(response.body)
      expect(json["photos"][0]["lat"]).to eq(data[0]["location"]["latitude"])
      expect(json["photos"][0]["lng"]).to eq(data[0]["location"]["longitude"])
      expect(json["photos"][0]["location_name"]).to eq(data[0]["location"]["name"])
      expect(json["photos"][0]["thumbnail"]).to eq(data[0]["images"]["thumbnail"]["url"])
      expect(json["photos"][0]["standard_resolution"]).to eq(data[0]["images"]["standard_resolution"]["url"])
      
      expect(subject).to be_success
    end  
  end
end