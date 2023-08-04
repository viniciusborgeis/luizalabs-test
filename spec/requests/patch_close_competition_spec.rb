require 'rails_helper'

RSpec.describe 'Close Competition', type: :request do
  describe 'PATCH /competitions/:id/close' do
    before do
      FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', password: '123456',
                               role: 'committee')
      FactoryBot.create(:user, id: 2, name: 'Athlete', email: 'athlete@email.com', password: '123456',
                               role: 'athlete')
      FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
      FactoryBot.create(:competition, id: 1, name: '100m rasos', modality_id: 1, closed: false)
      FactoryBot.create(:competition, id: 2, name: '100m rasos2', modality_id: 1, closed: true)
    end

    it 'should return status code 401 when user is not logged in' do
      patch '/competitions/1/close'
      expect(response).to have_http_status(401)
    end

    it 'should return a error message when user is not a committee' do
      post '/login', params: { user: { email: 'athlete@email.com', password: '123456' } }
      token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

      patch '/competitions/1/close', headers: { Authorization: "Bearer #{token}" }
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:status][:code]).to eq(403)
      expect(body[:status][:message]).to eq('You are not authorized to perform this action.')
    end

    it 'should return a error message when competition is already closed' do
      post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
      token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

      patch '/competitions/2/close', headers: { Authorization: "Bearer #{token}" }
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:status]).to eq(404)
      expect(body[:message]).to eq('Competition could not be closed successfully.')
    end

    it 'should return a error message when competition is not found' do
      post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
      token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

      patch '/competitions/5/close', headers: { Authorization: "Bearer #{token}" }
      body = JSON.parse(response.body, symbolize_names: true)

      expect(body[:status]).to eq(404)
      expect(body[:message]).to eq('Competition could not be closed successfully.')
    end

    it 'should return a success message when competition is closed successfully' do
      post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
      token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

      patch '/competitions/1/close', headers: { Authorization: "Bearer #{token}" }
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:status][:code]).to eq(200)
      expect(body[:status][:message]).to eq('Competition closed successfully.')
      expect(body[:data][:competition][:closed]).to eq(true)
      expect(body[:data][:competition][:id]).to eq(1)
      expect(body[:data][:competition][:name]).to eq('100m rasos')
      expect(body[:data][:competition][:modality][:name]).to eq('100m rasos')
      expect(body[:data][:competition][:modality][:unit]).to eq('seconds')
    end
  end
end
