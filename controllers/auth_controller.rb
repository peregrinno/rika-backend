# Login
post '/login' do
  user = User.find_by(email: @request_payload['email'])
  
  if user && user.password == @request_payload['password']
    token = JWT.encode(
      {
        user_id: user.id,
        exp: Time.now.to_i + 3600 # Token expira em 1 hora
      },
      JWT_SECRET,
      'HS256'
    )
    
    {token: token}.to_json
  else
    status 401
    {error: 'Credenciais inválidas'}.to_json
  end
end

# Registro
post '/register' do
  user = User.new(
    email: @request_payload['email'],
    name: @request_payload['name'],
    phone: @request_payload['phone']
  )
  user.password = @request_payload['password']

  if user.save
    status 201
    user.to_json(except: :password_hash)
  else
    status 400
    {errors: user.errors.full_messages}.to_json
  end
end 