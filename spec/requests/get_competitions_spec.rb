require 'rails_helper'

RSpec.describe 'Competitions', type: :request do
  describe 'GET /competitions' do

    describe 'withou competitions' do
        before do
            get '/competitions'
        end

        it 'should return status code 200' do
            expect(response).to have_http_status(200)
        end

        it 'should return an empty competitions array' do
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:data][:competitions].size).to eq(0)
        end

        it 'should return the correct status code and message' do
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:status][:code]).to eq(200)
            expect(body[:status][:message]).to eq('Competitions retrieved successfully.')
        end

        it 'should return an empty competitions array' do
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:data][:competitions]).to eq([])
        end
    end

    describe 'with some competitions' do
        before do
          FactoryBot.create(:user, id: 1, name: 'Cleber', email: 'cleber@email.com', role: 'committee')
          FactoryBot.create(:user, id: 2, name: 'João', email: 'joao@email.com', role: 'athlete')
          FactoryBot.create(:user, id: 3, name: 'Maria', email: 'maria@email.com', role: 'athlete')
    
          FactoryBot.create(:modality, id: 1, name: '100m rasos', unit: 'seconds')
          FactoryBot.create(:modality, id: 2, name: 'Lançamento de Dardo', unit: 'meters')
    
          FactoryBot.create(:competition, id: 1, name: '100m rasos', modality_id: 1, user_id: 1)
          FactoryBot.create(:competition, id: 2, name: 'Lançamento de Dardo', modality_id: 2, user_id: 1)
        end

        describe 'without results' do
          before do
            get '/competitions'
          end
    
          it 'should return status code 200' do
            expect(response).to have_http_status(200)
          end
    
          it 'should return all competitions' do
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:data][:competitions].size).to eq(2)
          end
    
          it 'should return the competitions with the correct attributes' do
            body = JSON.parse(response.body, symbolize_names: true)
    
            expect(body[:status][:code]).to eq(200)
            expect(body[:status][:message]).to eq('Competitions retrieved successfully.')
    
            expect(body[:data][:competitions][0][:name]).to eq('100m rasos')
            expect(body[:data][:competitions][1][:name]).to eq('Lançamento de Dardo')
    
            expect(body[:data][:competitions][0][:modality][:name]).to eq('100m rasos')
            expect(body[:data][:competitions][1][:modality][:name]).to eq('Lançamento de Dardo')
    
            expect(body[:data][:competitions][0][:closed]).to eq(false)
            expect(body[:data][:competitions][1][:closed]).to eq(false)
    
            expect(body[:data][:competitions][0][:modality][:unit]).to eq('seconds')
            expect(body[:data][:competitions][1][:modality][:unit]).to eq('meters')
    
            expect(body[:data][:competitions][0][:participants]).to eq(0)
            expect(body[:data][:competitions][1][:participants]).to eq(0)
    
            expect(body[:data][:competitions][0][:winner]).to eq([])
            expect(body[:data][:competitions][1][:winner]).to eq([])
    
            expect(body[:data][:competitions][0][:best_results]).to eq([])
            expect(body[:data][:competitions][1][:best_results]).to eq([])
          end
        end

        describe 'with results' do
          before do
            FactoryBot.create(:result, id: 1, value: 10.0, competition_id: 1, user_id: 2)
            FactoryBot.create(:result, id: 2, value: 9.0, competition_id: 1, user_id: 3)
            FactoryBot.create(:result, id: 3, value: 8.0, competition_id: 2, user_id: 2)
            FactoryBot.create(:result, id: 4, value: 7.0, competition_id: 2, user_id: 3)
            get '/competitions'
          end
    
          it 'should return status code 200' do
            expect(response).to have_http_status(200)
          end
    
          it 'should return all competitions' do
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:data][:competitions].size).to eq(2)
          end
    
          it 'should return the competitions with the correct attributes' do
            body = JSON.parse(response.body, symbolize_names: true)
    
            expect(body[:status][:code]).to eq(200)
            expect(body[:status][:message]).to eq('Competitions retrieved successfully.')
    
            expect(body[:data][:competitions][0][:name]).to eq('100m rasos')
            expect(body[:data][:competitions][1][:name]).to eq('Lançamento de Dardo')
    
            expect(body[:data][:competitions][0][:modality][:name]).to eq('100m rasos')
            expect(body[:data][:competitions][1][:modality][:name]).to eq('Lançamento de Dardo')
    
            expect(body[:data][:competitions][0][:closed]).to eq(false)
            expect(body[:data][:competitions][1][:closed]).to eq(false)
    
            expect(body[:data][:competitions][0][:modality][:unit]).to eq('seconds')
            expect(body[:data][:competitions][1][:modality][:unit]).to eq('meters')
    
            expect(body[:data][:competitions][0][:participants]).to eq(2)
            expect(body[:data][:competitions][1][:participants]).to eq(2)
    
            expect(body[:data][:competitions][0][:winner]).to eq([])
            expect(body[:data][:competitions][1][:winner]).to eq([])
    
            expect(body[:data][:competitions][0][:best_results]).to eq([9.0, 10.0])
            expect(body[:data][:competitions][1][:best_results]).to eq([8.0, 7.0])
          end
        end

        describe 'with closed and winners' do
          before do
            FactoryBot.create(:competition, id: 3, name: 'Lançamento de Dardo 2', modality_id: 2, user_id: 1,
                                            closed: true)
    
            FactoryBot.create(:result, id: 1, value: 10.0, competition_id: 1, user_id: 2)
            FactoryBot.create(:result, id: 2, value: 9.0, competition_id: 1, user_id: 3)
            FactoryBot.create(:result, id: 3, value: 8.0, competition_id: 2, user_id: 2)
            FactoryBot.create(:result, id: 4, value: 7.0, competition_id: 2, user_id: 3)
            FactoryBot.create(:result, id: 5, value: 6.0, competition_id: 3, user_id: 2)
            FactoryBot.create(:result, id: 6, value: 5.0, competition_id: 3, user_id: 3)
            get '/competitions'
          end
    
          it 'should return status code 200' do
            expect(response).to have_http_status(200)
          end
    
          it 'should return all competitions' do
            body = JSON.parse(response.body, symbolize_names: true)
            expect(body[:data][:competitions].size).to eq(3)
          end
    
          it 'should return the competitions with the correct attributes' do
            body = JSON.parse(response.body, symbolize_names: true)
    
            expect(body[:status][:code]).to eq(200)
            expect(body[:status][:message]).to eq('Competitions retrieved successfully.')
    
            expect(body[:data][:competitions][0][:name]).to eq('100m rasos')
            expect(body[:data][:competitions][1][:name]).to eq('Lançamento de Dardo')
            expect(body[:data][:competitions][2][:name]).to eq('Lançamento de Dardo 2')
    
            expect(body[:data][:competitions][0][:modality][:name]).to eq('100m rasos')
            expect(body[:data][:competitions][1][:modality][:name]).to eq('Lançamento de Dardo')
            expect(body[:data][:competitions][2][:modality][:name]).to eq('Lançamento de Dardo')
    
            expect(body[:data][:competitions][0][:modality][:unit]).to eq('seconds')
            expect(body[:data][:competitions][1][:modality][:unit]).to eq('meters')
            expect(body[:data][:competitions][2][:modality][:unit]).to eq('meters')
    
            expect(body[:data][:competitions][0][:closed]).to eq(false)
            expect(body[:data][:competitions][1][:closed]).to eq(false)
            expect(body[:data][:competitions][2][:closed]).to eq(true)
    
            expect(body[:data][:competitions][0][:participants]).to eq(2)
            expect(body[:data][:competitions][1][:participants]).to eq(2)
            expect(body[:data][:competitions][2][:participants]).to eq(2)
    
            expect(body[:data][:competitions][0][:winner]).to eq([])
            expect(body[:data][:competitions][1][:winner]).to eq([])
            expect(body[:data][:competitions][2][:winner]).to eq([{ name: 'João', value: 6.0 }])
    
            expect(body[:data][:competitions][0][:best_results]).to eq([9.0, 10.0])
            expect(body[:data][:competitions][1][:best_results]).to eq([8.0, 7.0])
            expect(body[:data][:competitions][2][:best_results]).to eq([6.0, 5.0])
          end
        end
    end

  end
end
