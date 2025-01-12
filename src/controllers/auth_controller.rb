require_relative 'base_controller'
require_relative '../contracts/auth_contract'

class AuthController < BaseController
  def login
    data = validate_with(Contracts::LoginContract)
    
    user = User.first(email: data[:email])
    
    if user && user.password == data[:password]
      token = JWT.encode(
        {
          user_id: user.id,
          exp: Time.now.to_i + 3600 # Token expira em 1 hora
        },
        JWT_SECRET,
        'HS256'
      )
      
      ResponseData.success({ token: token })
    else
      ResponseData.error('Credenciais inválidas', 401)
    end
  end

  def register
    data = validate_with(Contracts::RegisterContract)
    
    user = User.new(
      email: data[:email],
      name: data[:name],
      phone: data[:phone]
    )
    user.password = data[:password]

    if user.save
      ResponseData.success(user, 201)
    else
      ResponseData.error(user.errors, 400)
    end
  rescue Sequel::UniqueConstraintViolation
    ResponseData.error('Email já cadastrado', 400)
  rescue => e
    ResponseData.error(e.message, 500)
  end
end 