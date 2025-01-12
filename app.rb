require 'sinatra'
require 'jwt'
require 'json'
require 'bcrypt'
require 'dotenv'
require 'sequel'
require 'dry/validation'
require 'active_support'
require 'active_support/core_ext/time'

# Carrega o .env explicitamente do diretório raiz
Dotenv.load(File.expand_path('../.env', __FILE__))

# Define o ambiente
ENV['RACK_ENV'] ||= 'development'

# Configura o timezone padrão
Time.zone = 'America/Recife'

# Carrega a configuração do banco de dados
require_relative 'src/config/database'

# Carrega os arquivos de suporte
Dir["./src/lib/*.rb"].each {|file| require file }
Dir["./src/contracts/*.rb"].each {|file| require file }
Dir["./src/models/*.rb"].each {|file| require file }
Dir["./src/controllers/*.rb"].each {|file| require file }
Dir["./src/routes/*.rb"].each {|file| require file }

# Configurações da API
set :api_name, ENV['API_NAME']

# Configuração do JWT
JWT_SECRET = ENV['JWT_SECRET'] 