require_relative 'auth_routes'
require_relative 'cycle_routes'

class Router < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    content_type :json
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
  end

  options '*' do
    response.headers['Allow'] = 'GET, POST, PUT, DELETE, OPTIONS'
    200
  end

  # Monta as rotas
  use AuthRoutes
  use CycleRoutes
end 