require "rails_helper"

RSpec.describe FeedsController do
  
  describe '#index' do
    before do
      session[:access_token] = 'access_token'
      allow(controller).to receive(:auth_instagram).and_return true
    end
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
    let(:photos) do
      {
        lat: 48.8731995,
        lng: 2.3324201,
        infowindow: "Galeries Lafayette Haussmann"
      }
    end
    before do
      allow(InstagramService).to receive(:media_search).and_return data
  	end
    it 'render template index' do
      get :index
      expect(response).to render_template("index")
    end 
    context 'when passing parameter: lat and lng' do
      it 'return results data' do
        get :index, :lat=> 48.8731995, :lng=> 2.3324201 
        expect(assigns(:res)).to eq(data)
        expect(assigns(:photos)).to eq([photos])
      end 
    end
    context 'when no passing parameter' do
      it 'return empty data' do
        get :index
        expect(assigns(:res)).to be_nil
        expect(assigns(:photos)).to be_nil
      end 
    end
  end
end