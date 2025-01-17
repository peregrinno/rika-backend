require 'sinatra'
require 'jwt'
require 'json'
require 'bcrypt'
require 'dotenv'
require 'sequel'
require 'dry/validation'
require 'active_support'
require 'active_support/core_ext/time'
require 'rack/cors'
require 'sinatra/cross_origin'

# Carrega o .env explicitamente do diretório raiz
Dotenv.load(File.expand_path('../.env', __FILE__))

# Define o ambiente
ENV['RACK_ENV'] ||= 'development'

# Configura o timezone padrão
Time.zone = 'America/Recife'

# Configuração CORS para execução direta
configure do
  enable :cross_origin
  
  set :allow_origin, ENV['CORS_URL']
  set :allow_methods, [:get, :post, :put, :patch, :delete, :options]
  set :allow_credentials, true
  set :max_age, "1728000"
  set :expose_headers, ['Content-Type']
end

before do
  response.headers['Access-Control-Allow-Origin'] = ENV['CORS_URL']
  response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept'
  response.headers['Access-Control-Allow-Credentials'] = 'true'
end

options "*" do
  response.headers["Allow"] = "GET, POST, PUT, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept"
  200
end

# Carrega a configuração do banco de dados
require_relative 'src/config/database'

# Carrega os arquivos de suporte
Dir["./src/lib/*.rb"].each {|file| require file }
Dir["./src/middlewares/*.rb"].each {|file| require file }
Dir["./src/contracts/*.rb"].each {|file| require file }
Dir["./src/models/*.rb"].each {|file| require file }
Dir["./src/controllers/*.rb"].each {|file| require file }
Dir["./src/routes/*.rb"].each {|file| require file }
Dir["./src/services/*.rb"].each {|file| require file }

# Configurações da API
set :api_name, ENV['API_NAME']

# Configuração do JWT
JWT_SECRET = ENV['JWT_SECRET'] 

# Usando rackup (recomendado para produção)
#rerun 'rackup -o 0.0.0.0 -p 4567'

# Ou diretamente com ruby (bom para desenvolvimento rápido)
#ruby app.rb