require 'sinatra'
require 'sinatra/activerecord'
require 'jwt'
require 'json'
require 'bcrypt'
require 'dotenv/load' # Carrega as variáveis de ambiente

# Configurações da API
set :api_name, ENV['API_NAME']
set :timezone, ENV['TIMEZONE']
Time.zone = ENV['TIMEZONE']

# Configuração CORS
before do
  headers 'Access-Control-Allow-Origin' => ENV['CORS_URL'],
          'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT', 'DELETE'],
          'Access-Control-Allow-Headers' => 'Content-Type, Authorization'
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization"
  200
end

# Carrega todos os arquivos dos diretórios
Dir["./models/*.rb"].each {|file| require file }
Dir["./controllers/*.rb"].each {|file| require file }

# Configuração do banco de dados
set :database, {
  adapter: ENV['DB_ADAPTER'],
  host: ENV['DB_HOST'],
  database: ENV['DB_NAME'],
  username: ENV['DB_USERNAME'],
  password: ENV['DB_PASSWORD'],
  port: ENV['DB_PORT']
}

# Configuração do JWT
JWT_SECRET = ENV['JWT_SECRET']

# Middleware para processar JSON
before do
  content_type :json
  request.body.rewind
  @request_payload = JSON.parse(request.body.read) rescue {}
end 