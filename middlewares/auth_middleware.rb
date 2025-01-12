def authenticate!
  auth_header = request.env['HTTP_AUTHORIZATION']
  if auth_header
    token = auth_header.split(' ').last
    begin
      payload = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
      @current_user = User.find(payload['user_id'])
    rescue JWT::ExpiredSignature
      halt 401, {error: 'Token expirado'}.to_json
    rescue JWT::DecodeError
      halt 401, {error: 'Token inválido'}.to_json
    rescue ActiveRecord::RecordNotFound
      halt 401, {error: 'Usuário não encontrado'}.to_json
    end
  else
    halt 401, {error: 'Token não fornecido'}.to_json
  end
end 