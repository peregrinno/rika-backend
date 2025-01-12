require_relative 'auth_routes'
require_relative '../lib/cors_headers'

class Router < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    content_type :json
    headers CorsHeaders.set_cors_headers(ENV)
  end

  options "*" do
    200
  end

  # Monta as rotas
  use AuthRoutes
end 