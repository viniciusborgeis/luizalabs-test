require 'rails_helper'

RSpec.describe 'Competitions', type: :request do
  describe 'GET /competitions/:id' do
    describe 'with an invalid id' do
      before do
        get '/competitions/0'
      end

      it 'should return status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'should return the correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status]).to eq(404)
        expect(body[:message]).to eq('Competition not found.')
      end
    end

    describe 'with a valid id' do
      describe 'without results' do
        before do
          FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', role: 'committee')
          FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
          FactoryBot.create(:competition, id: 1, name: '100m rasos', modality_id: 1, user_id: 1)

          get '/competitions/1'
        end

        it 'should return status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'should return the correct status code and message' do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:status][:code]).to eq(200)
          expect(body[:status][:message]).to eq('Competition retrieved successfully.')
        end

        it 'should return the correct competition attributes' do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:data][:competition][:id]).to eq(1)
          expect(body[:data][:competition][:name]).to eq('100m rasos')
          expect(body[:data][:competition][:closed]).to eq(false)
          expect(body[:data][:competition][:modality][:name]).to eq('100m rasos')
          expect(body[:data][:competition][:modality][:unit]).to eq('seconds')
          expect(body[:data][:competition][:participants]).to eq(0)
          expect(body[:data][:competition][:winner]).to eq([])
          expect(body[:data][:competition][:all_results]).to eq([])
        end
      end

      describe 'with results without winner' do
        before do
          FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', role: 'committee')
          FactoryBot.create(:user, id: 2, name: 'Athlete1', email: 'athlete1@email.com', role: 'athlete')
          FactoryBot.create(:user, id: 3, name: 'Athlete2', email: 'athlete2@email.com', role: 'athlete')

          FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
          FactoryBot.create(:competition, id: 1, name: '100m rasos', modality_id: 1, user_id: 1)

          FactoryBot.create(:result, id: 1, value: 10.0, user_id: 2, competition_id: 1)
          FactoryBot.create(:result, id: 2, value: 11.0, user_id: 3, competition_id: 1)

          get '/competitions/1'
        end

        it 'should return status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'should return the correct status code and message' do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:status][:code]).to eq(200)
          expect(body[:status][:message]).to eq('Competition retrieved successfully.')
        end

        it 'should return the correct competition attributes without winner' do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:data][:competition][:id]).to eq(1)
          expect(body[:data][:competition][:name]).to eq('100m rasos')
          expect(body[:data][:competition][:closed]).to eq(false)
          expect(body[:data][:competition][:modality][:name]).to eq('100m rasos')
          expect(body[:data][:competition][:modality][:unit]).to eq('seconds')
          expect(body[:data][:competition][:participants]).to eq(2)
          expect(body[:data][:competition][:winner]).to eq([])

          all_results_data = [{ id: 2, name: 'Athlete1', value: 10.0 },
                              { id: 3, name: 'Athlete2', value: 11.0 }]
          expect(body[:data][:competition][:all_results]).to eq(all_results_data)
        end
      end

      describe 'with results with winner' do
        before do
          FactoryBot.create(:user, id: 1, name: 'Committee', email: 'committee@email.com', role: 'committee')
          FactoryBot.create(:user, id: 2, name: 'Athlete1', email: 'athlete1@email.com', role: 'athlete')
          FactoryBot.create(:user, id: 3, name: 'Athlete2', email: 'athlete2@email.com', role: 'athlete')

          FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
          FactoryBot.create(:competition, id: 1, name: '100m rasos', modality_id: 1, user_id: 1, closed: true)

          FactoryBot.create(:result, id: 1, value: 10.0, user_id: 2, competition_id: 1)
          FactoryBot.create(:result, id: 2, value: 11.0, user_id: 3, competition_id: 1)

          get '/competitions/1'
        end

        it 'should return status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'should return the correct status code and message' do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:status][:code]).to eq(200)
          expect(body[:status][:message]).to eq('Competition retrieved successfully.')
        end

        it 'should return the correct competition attributes without winner' do
          body = JSON.parse(response.body, symbolize_names: true)
          expect(body[:data][:competition][:id]).to eq(1)
          expect(body[:data][:competition][:name]).to eq('100m rasos')
          expect(body[:data][:competition][:closed]).to eq(true)
          expect(body[:data][:competition][:modality][:name]).to eq('100m rasos')
          expect(body[:data][:competition][:modality][:unit]).to eq('seconds')
          expect(body[:data][:competition][:participants]).to eq(2)
          expect(body[:data][:competition][:winner]).to eq([{ name: 'Athlete1', value: 10.0 }])

          all_results_data = [{ id: 2, name: 'Athlete1', value: 10.0 },
                              { id: 3, name: 'Athlete2', value: 11.0 }]
          expect(body[:data][:competition][:all_results]).to eq(all_results_data)
        end
      end
    end
  end
end
