require 'rails_helper'

RSpec.describe 'Modalities', type: :request do
  describe 'POST /modalities' do
    context 'with valid parameters' do
      before do
        FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', password: '123456',
                                 role: 'committee')
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/modalities', params: { name: 'Lançamento de Dardo', unit: 'meters' },
                            headers: { Authorization: "Bearer #{token}" }
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'should return correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(201)
        expect(body[:status][:message]).to eq('Modality created successfully.')
      end

      it 'should return correct modality data' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:modality][:id].is_a?(Integer)).to eq(true)
        expect(body[:data][:modality][:name]).to eq('Lançamento de Dardo')
        expect(body[:data][:modality][:unit]).to eq('meters')
      end
    end

    context 'with invalid parameters' do
      before do
        FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', password: '123456',
                                 role: 'committee')
        FactoryBot.create(:user, id: 2, name: 'Athlete', email: 'athlete@email.com', password: '123456',
                                 role: 'athlete')
      end

      it 'should return status code 401 when user is not logged in' do
        post '/modalities', params: { name: 'Lançamento de Dardo', unit: 'meters' }
        expect(response).to have_http_status(401)
      end

      it 'should return a error message when user is not a committee' do
        post '/login', params: { user: { email: 'athlete@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/modalities', params: { name: 'Lançamento de Dardo', unit: 'meters' },
                            headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)

        expect(body[:status][:code]).to eq(403)
        expect(body[:status][:message]).to eq('You are not authorized to perform this action.')
      end

      it 'should return status code 422 when name is not present' do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/modalities', params: { unit: 'meters' },
                            headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(422)
        expect(body[:status][:message]).to eq('Modality could not be created successfully.')
        expect(body[:data][:errors]).to eq('Name can\'t be blank')
      end

      it 'should return status code 422 when unit is not present' do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/modalities', params: { name: 'Lançamento de Dardo' },
                            headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status]).to eq(422)
        expect(body[:message]).to eq('invalid unit.')
      end
    end
  end
end
