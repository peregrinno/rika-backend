require_relative '../lib/api_response'
require_relative '../lib/http_response'

module AuthMiddleware
  include ApiResponse
  include HttpResponse

  def authenticate!
    auth_header = request.env['HTTP_AUTHORIZATION']
    if auth_header
      token = auth_header.split(' ').last
      begin
        payload = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
        user = User[payload['user_id']]
        unless user
          response = ResponseData.error('Usuário não encontrado', 401).to_json
          throw :halt, error_response(response, 401)
        end
        return user
      rescue JWT::ExpiredSignature
        response = ResponseData.error('Token expirado', 401).to_json
        throw :halt, error_response(response, 401)
      rescue JWT::DecodeError
        response = ResponseData.error('Token inválido', 401).to_json
        throw :halt, error_response(response, 401)
      end
    else
      response = ResponseData.error('Token não fornecido', 401).to_json
      throw :halt, error_response(response, 401)
    end
  end

  def request
    @request ||= Sinatra::Request.new(env)
  end

  def env
    @env ||= @request_payload.fetch(:env, {})
  end
end 