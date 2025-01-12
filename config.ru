require './app'
require 'sinatra'
require 'rack/cors'

use Rack::Cors do
  allow do
    if ENV['RACK_ENV'] == 'development'
      # Em desenvolvimento, permite localhost:3000 especificamente
      origins 'http://localhost:3000'
    else
      # Em produção, usa a URL configurada
      origins ENV['CORS_URL']
    end

    resource '*',
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      headers: :any,
      credentials: true,
      max_age: 600
  end
end

map('/') { run Router } 