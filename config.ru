require './app'
require 'sinatra'
require 'stringio'

# Middleware para preservar o body da requisição
class PreserveRequestBody
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['CONTENT_TYPE'] == 'application/json'
      body = env['rack.input'].read
      env['raw_body'] = body
      env['rack.input'] = StringIO.new(body)
    end
    @app.call(env)
  end
end

use PreserveRequestBody
map('/') { run Router } 