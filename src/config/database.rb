require 'sequel'

DB = Sequel.connect(
  adapter: 'postgres',
  host: 'localhost',
  database: ENV['DB_NAME'],
  user: ENV['DB_USERNAME'],
  password: ENV['DB_PASSWORD'],
  port: ENV['DB_PORT'].to_i
)

# Habilita extensões úteis do Sequel
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :timestamps, update_on_create: true 