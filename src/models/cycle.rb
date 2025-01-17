class Cycle < Sequel::Model
  many_to_one :user
  
  plugin :validation_helpers
  plugin :timestamps, update_on_create: true

  def validate
    super
    validates_presence [:id_user, :cycle_number, :first_day, :date, :day_of_cycle]
    validates_max_length 50, [:symbol, :feeling, :observation], allow_nil: true
    validates_max_length 255, [:notes], allow_nil: true
    
    # Validações adicionais
    errors.add(:first_day, 'deve ser uma data válida') unless valid_date?(first_day)
    errors.add(:date, 'deve ser uma data válida') unless valid_date?(date)
    errors.add(:day_of_cycle, 'deve ser maior que 0') if day_of_cycle && day_of_cycle <= 0
  end

  def before_create
    super
    self.r ||= false
    self.notes = '' if notes.nil? # Garante que notes seja string vazia se for nil
  end

  def before_save
    super
    self.notes = '' if notes.nil? # Garante que notes seja string vazia se for nil
  end

  private

  def valid_date?(date_string)
    return true if date_string.is_a?(Date)
    Date.parse(date_string.to_s)
    true
  rescue ArgumentError
    false
  end
end 