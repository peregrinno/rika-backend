require 'sinatra/json'
require_relative '../lib/cors_headers'

class AuthRoutes < Sinatra::Base
  helpers Sinatra::JSON

  configure do
    enable :cross_origin
  end

  before do
    content_type :json
    headers CorsHeaders.set_cors_headers(ENV)
    @request_payload = JSON.parse(request.body.read) rescue {}
  end

  options "*" do
    200
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
end 