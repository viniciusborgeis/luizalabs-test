require 'rails_helper'

RSpec.describe 'Competition Result', type: :request do
  describe 'POST /competitions/:id/results' do
    before do
      FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', password: '123456',
                               role: 'committee')
      FactoryBot.create(:user, id: 2, name: 'Athlete', email: 'athlete@email.com', password: '123456',
                               role: 'athlete')
      FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
      FactoryBot.create(:modality, id: 2, name: 'Lançamento de Dardo', unit: 'meters')
      FactoryBot.create(:competition, id: 1, name: '100m rasos', modality_id: 1, closed: false)
      FactoryBot.create(:competition, id: 2, name: 'Lançamentos de dardos', modality_id: 2, closed: false)
      FactoryBot.create(:competition, id: 3, name: 'Lançamentos de dardos closed', modality_id: 2, closed: true)
    end

    describe 'with valid data' do
      before do
        post '/login', params: { user: { email: 'athlete@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions/1/results', params: { value: 10.0 },
                                        headers: { Authorization: "Bearer #{token}" }
      end

      it 'should return status code 201' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(201)
      end

      it 'should return correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(201)
        expect(body[:status][:message]).to eq('Result created successfully.')
      end

      it 'should return correct result data' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:result][:id].is_a?(Integer)).to eq(true)
        expect(body[:data][:result][:value]).to eq(10.0)
        expect(body[:data][:result][:competition_id]).to eq(1)
        expect(body[:data][:result][:user_id]).to eq(2)
      end
    end

    describe 'with invalid data' do
      before :each do
        FactoryBot.create(:result, id: 101, value: 10.0, competition_id: 2, user_id: 2)
        FactoryBot.create(:result, id: 102, value: 11.0, competition_id: 2, user_id: 2)
        FactoryBot.create(:result, id: 103, value: 12.0, competition_id: 2, user_id: 2)
      end

      it 'should return status code 401 when user is not logged in' do
        post '/competitions/1/results', params: { value: 10.0 },
                                        headers: { Authorization: 'Bearer ' }
        expect(response).to have_http_status(401)
      end

      it 'should return a error message when user is not a athlete' do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions/1/results', params: { value: 10.0 },
                                        headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(403)
        expect(body[:status][:code]).to eq(403)
        expect(body[:status][:message]).to eq('You are not authorized to perform this action.')
      end

      it 'should return a error message when competition is closed' do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions/3/results', params: { value: 10.0 },
                                        headers: { Authorization: "Bearer #{token}" }
        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(403)
        expect(body[:status][:code]).to eq(403)
        expect(body[:status][:message]).to eq('You are not authorized to perform this action.')
      end

      it 'should return a error message when result value is not a number' do
        post '/login', params: { user: { email: 'committee@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions/1/results', params: { value: 'a' },
                                        headers: { Authorization: "Bearer #{token}" }
        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(403)
        expect(body[:status][:code]).to eq(403)
        expect(body[:status][:message]).to eq('You are not authorized to perform this action.')
      end

      it 'should return a error message when competition darts has received three results at the same user' do
        post '/login', params: { user: { email: 'athlete@email.com', password: '123456' } }
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last

        post '/competitions/2/results', params: { value: 10.0 }, headers: { Authorization: "Bearer #{token}" }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(422)
        expect(body[:status]).to eq(422)
        expect(body[:message]).to eq('Result could not be created successfully.')
      end
    end
  end
end
