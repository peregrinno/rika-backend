module CorsHeaders
  def self.set_cors_headers(env)
    origin = if env['RACK_ENV'] == 'development'
      'http://localhost:3000'
    else
      ENV['CORS_URL']
    end

    {
      'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST', 'PUT', 'DELETE'].join(', '),
      'Access-Control-Allow-Headers' => 'Content-Type, Authorization, X-Requested-With, X-HTTP-Method-Override, Accept',
      'Access-Control-Allow-Origin' => origin,
      'Access-Control-Allow-Credentials' => 'true'
    }
  end
end 