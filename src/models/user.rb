class User < Sequel::Model
  include BCrypt
  
  plugin :validation_helpers

  def validate
    super
    validates_presence [:email, :password_hash, :name, :phone]
    validates_unique :email
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def to_json(options = {})
    values.reject { |k,v| k == :password_hash }.to_json
  end

  # Valores default para os novos campos
  def before_create
    super
    self.first_access ||= true
    self.verified ||= false
  end
end 