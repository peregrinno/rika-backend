require 'dry/validation'

module Contracts
  class RegisterContract < Dry::Validation::Contract
    params do
      required(:email).filled(:string).value(format?: URI::MailTo::EMAIL_REGEXP)
      required(:password).filled(:string).value(min_size?: 6)
      required(:name).filled(:string)
      required(:phone).filled(:string).value(format?: /\A\d{10,11}\z/)
    end

    rule(:password) do
      key.failure('deve conter letras e números') unless value.match?(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/)
    end
  end

  class LoginContract < Dry::Validation::Contract
    params do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end
  end
end 