require 'sinatra/json'

class CycleRoutes < Sinatra::Base
  helpers Sinatra::JSON

  before do
    content_type :json
    response.headers['Access-Control-Allow-Origin'] = ENV['CORS_URL']
    
    raw_body = env['raw_body'] || request.body.read
    @request_payload = JSON.parse(raw_body) rescue {}
    
    puts "\n=== Request Debug ==="
    puts "Method: #{request.request_method}"
    puts "Path: #{request.path}"
    puts "Content-Type: #{request.content_type}"
    puts "Content-Length: #{request.content_length}"
    puts "Raw Body: #{raw_body}"
    puts "Parsed Payload: #{@request_payload.inspect}"
  end

  post '/cycle/create' do
    controller = CycleController.new
    controller.set_request_env(env)
    controller.instance_variable_set(:@request_payload, @request_payload['data'])
    controller.create
  end

  get '/cycle/now/list' do
    controller = CycleController.new
    controller.set_request_env(env)
    controller.now_list
  end

  get '/cycle/list' do
    controller = CycleController.new
    controller.set_request_env(env)
    controller.list
  end

  put '/cycle/update' do
    controller = CycleController.new
    controller.set_request_env(env)
    controller.instance_variable_set(:@request_payload, @request_payload['data'])
    controller.update
  end

  get '/day-cycle' do
    controller = CycleController.new
    controller.set_request_env(env)
    controller.day_cycle_current
  end
end 