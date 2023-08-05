require 'rails_helper'

RSpec.describe 'Modalities', type: :request do
  describe 'GET /modalities' do
    describe 'without any modalities' do
      before do
        get '/modalities'
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return an empty modalities array' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:modalities].size).to eq(0)
      end

      it 'should return the correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(200)
        expect(body[:status][:message]).to eq('Modalities retrieved successfully.')
      end

      it 'should return an empty modalities array' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:modalities]).to eq([])
      end
    end

    describe 'with some modalities' do
      before do
        FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
        FactoryBot.create(:modality, id: 2, name: 'dardos', unit: 'meters')
        get '/modalities'
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return all modalities' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:modalities].size).to eq(2)
      end

      it 'should return the modalities with the correct attributes' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(200)
        expect(body[:status][:message]).to eq('Modalities retrieved successfully.')

        expect(body[:data][:modalities][0][:name]).to eq('100m rasos')
        expect(body[:data][:modalities][1][:name]).to eq('dardos')
        expect(body[:data][:modalities][0][:unit]).to eq('seconds')
        expect(body[:data][:modalities][1][:unit]).to eq('meters')
      end
    end
  end
end
