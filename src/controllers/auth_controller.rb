require_relative 'base_controller'
require_relative '../contracts/auth_contract'
require_relative '../services/mailer_service'
require_relative '../services/token_service'

class AuthController < BaseController
  def login
    data = validate_with(Contracts::LoginContract)
    
    user = User.first(email: data[:email])
    
    if user && user.password == data[:password]
      unless user.verified
        return ResponseData.error('Conta não verificada. Verifique seu email.', 401)
      end

      expiration_time = 60 # tempo em minutos
      token = JWT.encode(
        {
          user_id: user.id,
          exp: Time.now.to_i + (expiration_time * 60)
        },
        JWT_SECRET,
        'HS256'
      )
      
      ResponseData.success({ 
        token: token,
        'expires_in': expiration_time
      })
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
      send_verification_email(user)
      ResponseData.success(user, 201)
    else
      ResponseData.error(user.errors, 400)
    end
  rescue Sequel::UniqueConstraintViolation
    ResponseData.error('Email já cadastrado', 400)
  rescue => e
    ResponseData.error(e.message, 500)
  end

  def validate(token)
    token_data = TokenService.verify_token(token)
    
    if token_data && token_data['purpose'] == 'email_verification'
      user = User[token_data['user_id']]
      if user
        user.verified = true
        user.save
        ResponseData.success({ message: 'Email verificado com sucesso' })
      else
        ResponseData.error('Usuário não encontrado', 404)
      end
    else
      ResponseData.error('Token inválido ou expirado', 400)
    end
  end

  def validate_attempt
    data = validate_with(Contracts::EmailOnlyContract)
    user = User.first(email: data[:email])

    if user
      unless user.verified
        send_verification_email(user)
        ResponseData.success({ message: 'Email de verificação enviado' })
      else
        ResponseData.error('Conta já verificada', 400)
      end
    else
      ResponseData.error('Email não encontrado', 404)
    end
  end

  def me
    user = authenticate!
    ResponseData.success({ user_valid: user.verified })
  end

  private

  def send_verification_email(user)
    token = TokenService.generate_verification_token(user.id)
    MailerService.send_verification_email(user, token)
  end
end 