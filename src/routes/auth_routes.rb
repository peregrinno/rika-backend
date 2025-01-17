require 'sinatra/json'

class AuthRoutes < Sinatra::Base
  helpers Sinatra::JSON

  before do
    content_type :json
    response.headers['Access-Control-Allow-Origin'] = '*'
    @request_payload = JSON.parse(request.body.read) rescue {}
  end

  post '/login' do
    controller = AuthController.new
    controller.instance_variable_set(:@request_payload, @request_payload)
    controller.login
  end

  post '/register' do
    controller = AuthController.new
    controller.instance_variable_set(:@request_payload, @request_payload)
    controller.register
  end

  get '/validate' do
    controller = AuthController.new
    controller.validate(params[:token])
  end

  post '/validate-attempt' do
    controller = AuthController.new
    controller.instance_variable_set(:@request_payload, @request_payload)
    controller.validate_attempt
  end

  get '/me' do
    controller = AuthController.new
    controller.set_request_env(env)
    controller.me
  end
end 