require 'rails_helper'

RSpec.describe 'Signup', type: :request do
  describe 'POST /signup' do
    context 'with valid parameters' do
      before do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            password: '123456',
            name: 'Athlete',
            role: 'athlete'
          }
        }
      end

      it 'should return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'should return the correct status code and message' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(201)
        expect(body[:status][:message]).to eq('Signed up sucessfully.')
      end

      it 'should return the correct user' do
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:user][:id].to_i).to be_an(Integer)
        expect(body[:data][:user][:email]).to eq('athlete@test.com')
        expect(body[:data][:user][:name]).to eq('Athlete')
      end
    end

    context 'with invalid parameters' do
      it 'should return status code 422' do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            password: '123456',
            role: 'athlete'
          }
        }

        expect(response).to have_http_status(422)
      end

      it 'should return the correct status code and message' do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            password: '123456',
            role: 'athlete'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:status][:code]).to eq(422)
        expect(body[:status][:message]).to eq('User could not be created successfully.')
      end

      it 'should return message for missing name' do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            password: '123456',
            role: 'athlete'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:errors]).to eq("Name can't be blank")
      end

      it 'should return message for missing password' do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            name: 'Athlete',
            role: 'athlete'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:errors]).to eq("Password can't be blank and Password is too short (minimum is 6 characters)")
      end

      it 'should return message for missing email' do
        post '/signup', params: {
          user: {
            name: 'Athlete',
            password: '123456',
            role: 'athlete'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:errors]).to eq("Email can't be blank and Email is invalid")
      end

      it 'should return message for missing role' do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            name: 'Athlete',
            password: '123456'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:message]).to eq('Invalid or missing user role. only accept <athlete> or <committee>')
      end

      it 'should return message for empty email' do
        post '/signup', params: {
          user: {
            email: '',
            name: 'Athlete',
            password: '123456',
            role: 'athlete'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:errors]).to eq("Email can't be blank and Email is invalid")
      end

      it 'should return message for empty password' do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            name: 'Athlete',
            password: '',
            role: 'athlete'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:errors]).to eq("Password can't be blank and Password is too short (minimum is 6 characters)")
      end

      it 'should return message for empty name' do
        post '/signup', params: {
          user: {
            email: 'athlete@test.com',
            name: '',
            password: '123456',
            role: 'athlete'
          }
        }

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:data][:errors]).to eq("Name can't be blank")
      end
    end
  end
end
