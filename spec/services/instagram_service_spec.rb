require "rails_helper"

describe InstagramService do

  describe '.media_search' do
    let(:params) { nil }
    let(:status) { 200 }
    let(:response_data) { '{"data": "bar"}' }
    before do
      @response = Net::HTTPResponse.new("1.1", status, 'response data')
      allow(@response).to receive(:body).and_return(response_data)
      allow(HTTParty).to receive(:get).and_return(@response)
    end
    context 'when params is empty' do
      it 'expect do nothing' do
        expect(HTTParty).to_not receive(:get)
        InstagramService.media_search params
      end
    end
    context 'when has params' do
      let(:params) { {query: {} } }
      context 'when response is success' do
        it "expect return data" do
          expect(InstagramService.media_search(params)).to eql "bar"
          InstagramService.media_search(params)
        end
      end
      context 'when response failed' do
        let(:status) { 400 }
        it "expect raise error " do
          expect { InstagramService.media_search params }.to raise_error(InstagramRequestError)
        end
      end
    end  
  end
end