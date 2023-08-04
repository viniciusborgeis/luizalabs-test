require 'rails_helper'

RSpec.describe 'Competitions', type: :request do
  describe 'POST /competitions' do
    before do
      FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', password: '123456',
                               role: 'committee')
      FactoryBot.create(:user, id: 2, name: 'Athlete', email: 'athlete@email.com', password: '123456',
                               role: 'athlete')
      FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
      FactoryBot.create(:modality, id: 2, name: 'dardos', unit: 'meters')
    end

    describe 'with valid data' do
      before do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions', params: { name: 'Lançamentos de dardos', modality_id: 1 },
                              headers: { Authorization: "Bearer #{token}" }
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'should return correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(201)
        expect(body[:status][:message]).to eq('Competition created successfully.')
      end

      it 'should return correct competition data' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:competition][:id].is_a?(Integer)).to eq(true)
        expect(body[:data][:competition][:name]).to eq('Lançamentos de dardos')
        expect(body[:data][:competition][:closed]).to eq(false)
        expect(body[:data][:competition][:modality][:name]).to eq('100m rasos')
        expect(body[:data][:competition][:modality][:unit]).to eq('seconds')
      end
    end

    describe 'with invalid data' do
      it 'should return status code 401 when user is not logged in' do
        post '/competitions', params: { name: 'Lançamentos de dardos', modality_id: 1 }
        expect(response).to have_http_status(401)
      end

      it 'should return a error message when user is not a committee' do
        post '/login', params: { user: { email: 'athlete@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions', params: { name: 'Lançamentos de dardos', modality_id: 1 },
                              headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(403)
        expect(body[:status][:code]).to eq(403)
        expect(body[:status][:message]).to eq('You are not authorized to perform this action.')
      end

      it 'should return a error message when modality does not exist' do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions', params: { name: 'Lançamentos de dardos', modality_id: 5 },
                              headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(422)
        expect(body[:status][:code]).to eq(422)
        expect(body[:status][:message]).to eq('Competition could not be created successfully.')
        expect(body[:data][:errors]).to eq('Modality must exist, Modality can\'t be blank, and Modality is not included in the list')
      end

      it 'should return a error message when name is blank' do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions', params: { modality_id: 1 },
                              headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(422)
        expect(body[:status][:code]).to eq(422)
        expect(body[:status][:message]).to eq('Competition could not be created successfully.')
        expect(body[:data][:errors]).to eq('Name can\'t be blank')
      end
    end
  end
end
