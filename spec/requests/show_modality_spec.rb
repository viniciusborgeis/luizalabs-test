require 'rails_helper'

RSpec.describe 'Modalities', type: :request do
  describe 'GET /modalities/:id' do
    describe 'with an invalid id' do
      before do
        get '/modalities/0'
      end

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return the correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status]).to eq(404)
        expect(body[:message]).to eq('Modality not found.')
      end
    end

    describe 'with a valid id' do
      before do
        FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
        get '/modalities/1'
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return the correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(200)
        expect(body[:status][:message]).to eq('Modality retrieved successfully.')
      end

      it 'should return the correct modality' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:modality][:id]).to eq(1)
        expect(body[:data][:modality][:name]).to eq('100m rasos')
        expect(body[:data][:modality][:unit]).to eq('seconds')
      end
    end
  end
end
