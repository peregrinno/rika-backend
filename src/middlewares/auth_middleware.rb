require_relative '../lib/api_response'

def authenticate!
  include ApiResponse
  
  auth_header = request.env['HTTP_AUTHORIZATION']
  if auth_header
    token = auth_header.split(' ').last
    begin
      payload = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
      @current_user = User[payload['user_id']]
      halt 401, ResponseData.error('Usuário não encontrado', 401) unless @current_user
    rescue JWT::ExpiredSignature
      halt 401, ResponseData.error('Token expirado', 401)
    rescue JWT::DecodeError
      halt 401, ResponseData.error('Token inválido', 401)
    end
  else
    halt 401, ResponseData.error('Token não fornecido', 401)
  end
end 