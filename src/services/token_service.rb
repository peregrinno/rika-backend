class TokenService
  class << self
    def generate_verification_token(user_id)
      JWT.encode(
        {
          user_id: user_id,
          purpose: 'email_verification',
          exp: Time.now.to_i + (24 * 60 * 60), # 24 horas
          jti: SecureRandom.uuid # Token único
        },
        JWT_SECRET,
        'HS256'
      )
    end

    def verify_token(token)
      begin
        decoded = JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256')[0]
        
        # Verifica se o token já foi usado
        return false if DB[:used_tokens].where(jti: decoded['jti']).first
        
        # Marca o token como usado
        DB[:used_tokens].insert(jti: decoded['jti'], used_at: Time.now)
        
        decoded
      rescue JWT::ExpiredSignature
        false
      rescue JWT::DecodeError
        false
      end
    end
  end
end 