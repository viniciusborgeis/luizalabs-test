require 'rails_helper'

RSpec.describe 'Login', type: :request do
  describe 'POST /login' do
    context 'with valid parameters' do
      before do
        FactoryBot.create(:user, id: 1, email: 'athlete@test.com', password: '123456', name: 'Athlete', role: 'athlete')

        post '/login', params: {
          user: {
            email: 'athlete@test.com',
            password: '123456'
          }
        }
      end

      it 'should return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'should return the correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(200)
        expect(body[:status][:message]).to eq('Logged in sucessfully.')
      end

      it 'should return the correct user' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:user][:id].to_i).to be_an(Integer)
        expect(body[:data][:user][:email]).to eq('athlete@test.com')
        expect(body[:data][:user][:name]).to eq('Athlete')
      end

      it 'should return the correct token' do
        token = JSON.parse(response.header.to_json, symbolize_names: true)[:Authorization].split(' ').last
        secret_key = Rails.application.credentials.devise_jwt_secret_key!
        expect { JWT.decode(token, secret_key) }.to_not raise_error
      end
    end

    context 'with invalid parameters' do
      it 'should return status code 401' do
        post '/login', params: {
          user: {
            email: 'athlete@test.com',
            password: ''
          }
        }

        expect(response).to have_http_status(401)
      end

      it 'should return the correct status code and message for missing password' do
        post '/login', params: {
          user: {
            email: 'athlete@test.com',
            password: ''
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status]).to eq(401)
        expect(body[:message]).to eq('Invalid email or password.')
      end

      it 'should return the correct status code and message for missing email' do
        post '/login', params: {
          user: {
            email: '',
            password: '123456'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status]).to eq(401)
        expect(body[:message]).to eq('Invalid email or password.')
      end
    end
  end
end
