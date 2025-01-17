require 'net/smtp'
require 'mail'

class MailerService
  class << self
    def setup
      Mail.defaults do
        delivery_method :smtp, {
          address: ENV['SMTP_ADDRESS'],
          port: ENV['SMTP_PORT'],
          domain: ENV['SMTP_DOMAIN'],
          user_name: ENV['SMTP_USERNAME'],
          password: ENV['SMTP_PASSWORD'],
          authentication: ENV['SMTP_AUTH'],
          ssl: ENV['SMTP_ENABLE_SSL'] == 'true',
          tls: ENV['SMTP_ENABLE_SSL'] == 'true',
          enable_starttls_auto: false # Desabilita STARTTLS pois usaremos SSL
        }
      end
    end

    def send_verification_email(user, token)
      setup # Garante que as configurações estão aplicadas
      verification_link = "#{ENV['FRONTEND_URL']}/validate?token=#{token}"
      
      Mail.deliver do
        from    "#{ENV['API_NAME']} <#{ENV['SMTP_USERNAME']}>"
        to      user.email
        subject 'Verifique sua conta'
        content_type 'text/html; charset=UTF-8'
        body    <<~HTML
          <h2>Olá #{user.name},</h2>
          <p>Por favor, verifique sua conta clicando no link abaixo:</p>
          <p><a href="#{verification_link}">Verificar minha conta</a></p>
          <p>Ou copie e cole este link no seu navegador:</p>
          <p>#{verification_link}</p>
          <br>
          <p>Atenciosamente,<br>Equipe #{ENV['API_NAME']}</p>
        HTML
      end
    rescue => e
      puts "Erro ao enviar email: #{e.message}"
      raise e
    end
  end
end 